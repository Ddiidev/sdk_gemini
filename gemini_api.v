module sdk_gemini

import os
import json
import structs
import net.http
import log

pub struct GeminiSDK {
pub:
	api_key string
}

const base_url = 'https://generativelanguage.googleapis.com/v1beta/models'

// get_api_key Reads an Gemini API key from an environment variable.
pub fn get_api_key(key_var string) !string {
	api_key := os.getenv(key_var)
	if api_key == '' {
		return structs.KeyEmptyError{}
	}
	if !api_key.starts_with('AIza') {
		return structs.KeySequenceError{}
	}
	return api_key
}

// new Returns a GeminiSDK.
pub fn new(api_key string) GeminiSDK {
	return GeminiSDK{
		api_key: api_key
	}
}

// completation Sends a request to the Gemini API and returns the response or an error.
// Log level 'debug' logs the full model response body in case of an error occuring.
pub fn (mut sdk GeminiSDK) completation(model structs.Models, req_payload structs.GeminiRequest) !structs.GeminiResponse {
	url := '${base_url}/${model}:generateContent?key=${sdk.api_key}'

	payload := if model.is_gemma() {
		req_payload_addapted := adapt_to_gemma(req_payload)
		json.encode(req_payload_addapted)
	} else {
		json.encode(req_payload)
	}

	mut req := http.new_request(.post, url, payload)
	req.header.set(.content_type, 'application/json')

	resp := req.do()!

	match resp.status_code {
		400 {
			log.debug(resp.body)
			return structs.InvalidPayloadError{}
		}
		429 {
			log.debug(resp.body)
			return structs.ExceededQuotaError{}
		}
		503 {
			log.debug(resp.body)
			return structs.ModelOverloadedError{}
		}
		else {
			if resp.status_code != 200 {
				log.debug(resp.body)
				return structs.UnknownResponseError{}
			}
		}
	}

	decoded := json.decode(structs.GeminiResponse, resp.body)!

	return decoded
}

// adapt_to_gemma Adapts a GeminiRequest to the Gemma model.
// Gemma models do not support system instructions.
// This function moves the system instruction to the first content part.
fn adapt_to_gemma(req_payload structs.GeminiRequest) structs.GeminiRequest {
	mut req_payload_addapted := req_payload

	if req_payload_addapted.system_instruction != none {
		mut contents := []structs.Content{}
		for i, curr_content in req_payload_addapted.contents {
			if i == 0 {
				mut parts := curr_content.parts.clone()
				parts << req_payload_addapted.system_instruction.parts
				contents << structs.Content{
					role:  .user
					parts: parts
				}
			} else {
				contents << curr_content
			}
		}
		req_payload_addapted = structs.GeminiRequest{
			...req_payload_addapted
			contents:           contents
			system_instruction: none
		}
	}

	return req_payload_addapted
}

// send_prompt Sends a prompt to the Gemini API and returns the model's response.
pub fn (mut sdk GeminiSDK) send_prompt(model structs.Models, prompt string, system_instruction string) !structs.GeminiResponse {
	// Criar as partes do conteúdo
	user_part := structs.Part{
		text: prompt
	}

	user_content := structs.Content{
		role:  .user
		parts: [user_part]
	}

	mut sys_instruction := structs.SystemInstruction{}
	if system_instruction != '' {
		sys_part := structs.Part{
			text: system_instruction
		}
		sys_instruction = structs.SystemInstruction{
			parts: [sys_part]
		}
	}

	gen_config := structs.GenerationConfig{
		temperature:       0.7
		max_output_tokens: 1024
	}

	request := structs.GeminiRequest{
		contents:           [user_content]
		system_instruction: sys_instruction
		generation_config:  gen_config
	}

	return sdk.completation(model, request)
}
