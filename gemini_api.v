module sdk_gemini

import json
import structs
import net.http

pub struct GeminiSDK {
pub:
	api_key string
}

const base_url = 'https://generativelanguage.googleapis.com/v1beta/models'

// completation Sends a request to the Gemini API and returns the response.
pub fn (mut sdk GeminiSDK) completation(model structs.Models, req_payload structs.GeminiRequest) !structs.GeminiResponse {
	url := '${base_url}/${model}:generateContent?key=${sdk.api_key}'

	payload:= json.encode(req_payload)

	mut req := http.new_request(.post, url, payload)
	req.header.set(.content_type, 'application/json')

	resp := req.do()!

	if resp.status_code != 200 {
		return error_with_code(resp.body, resp.status_code)
	}

	decoded := json.decode(structs.GeminiResponse, resp.body)!

	return decoded
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
