module tests

import os
import structs
import sdk_gemini

const prompt_capital = 'What is the capital of Brazil?'
const system_instruction = 'Answer with the single-word capital of Brazil, with no accents, punctuation, or extra text.'

fn assert_model_returns_brasilia(model structs.Models) {
	api_key := os.getenv('GEMINI_API_KEY')
	if api_key == '' {
		assert false, 'GEMINI_API_KEY not set'
		return
	}
	mut sdk := sdk_gemini.GeminiSDK{
		api_key: api_key
	}

	user_part := structs.Part{
		text: prompt_capital
	}

	user_content := structs.Content{
		role:  .user
		parts: [user_part]
	}

	sys_part := structs.Part{
		text: system_instruction
	}

	sys_instruction := structs.SystemInstruction{
		parts: [sys_part]
	}

	gen_config := structs.GenerationConfig{
		temperature:       0.0
		top_k:             1
		top_p:             0.1
		max_output_tokens: 1024
	}

	request := structs.GeminiRequest{
		contents:           [user_content]
		system_instruction: sys_instruction
		generation_config:  gen_config
	}

	response := sdk.completation(model, request) or {
		assert false, err.msg()
		return
	}

	assert response.candidates.len > 0
	assert response.candidates[0].content.parts.len > 0
	text := response.candidates[0].content.parts[0].text.trim_space().to_upper()
	assert text == 'BRASILIA' || text == 'BRASÍLIA', ''
}

fn test_model_gemma_3_1b_it() {
	assert_model_returns_brasilia(.gemma_3_1b_it)
}

fn test_model_gemma_3_4b_it() {
	assert_model_returns_brasilia(.gemma_3_4b_it)
}

fn test_model_gemma_3_12b_it() {
	assert_model_returns_brasilia(.gemma_3_12b_it)
}

fn test_model_gemma_3_27b_it() {
	assert_model_returns_brasilia(.gemma_3_27b_it)
}

fn test_model_gemini_2_5_flash_lite() {
	assert_model_returns_brasilia(.gemini_2_5_flash_lite)
}

fn test_model_gemini_2_5_flash() {
	assert_model_returns_brasilia(.gemini_2_5_flash)
}

fn test_model_gemini_3_0_flash_preview() {
	assert_model_returns_brasilia(.gemini_3_0_flash_preview)
}
