# Gemini V SDK

A V language SDK for interacting with Google's Gemini AI API. This module provides a simple and efficient way to integrate Gemini's generative AI capabilities into your V applications.

## Features

- Support for multiple free Gemini models (1.5 Flash, 2.0 Flash, 2.5 Flash variants) - PRs welcome for paid models
- Simple prompt-based text generation
- Advanced request configuration with system instructions
- Comprehensive response handling
- Type-safe API with structured data models
- Built-in error handling

## Installation

```bash
v install sdk_gemini
```

## Quick Start

```v
import sdk_gemini
import structs

// Initialize the SDK with your API key
mut sdk := sdk_gemini.GeminiSDK{
    api_key: 'your-api-key-here'
}

// Send a simple prompt
response := sdk.send_prompt(
    structs.Models.gemini_2_0_flash,
    'Tell me about João Pessoa, Paraíba',
    'You are a tour guide from Brazil, specifically from the Northeast region, João Pessoa and Paraíba state'
) or {
    panic('Failed to get response: ${err}')
}

// Access the response
if response.candidates.len > 0 {
    println(response.candidates[0].content.parts[0].text)
}
```

## API Reference

### GeminiSDK

The main SDK struct for interacting with the Gemini API.

```v
pub struct GeminiSDK {
pub:
    api_key string
}
```

#### Methods

##### `completation(model Models, req_payload GeminiRequest) !GeminiResponse`

Sends a complete request to the Gemini API with full control over the request structure.

**Parameters:**
- `model`: The Gemini model to use (see Models enum)
- `req_payload`: Complete request configuration

**Returns:** `GeminiResponse` or error

##### `send_prompt(model Models, prompt string, system_instruction string) !GeminiResponse`

Simplified method for sending text prompts with optional system instructions.

**Parameters:**
- `model`: The Gemini model to use
- `prompt`: The user prompt/question
- `system_instruction`: Optional system instruction (can be empty string)

**Returns:** `GeminiResponse` or error

### Supported Models

The SDK supports the following Gemini models:

- `gemini_1_5_flash_8b` - Gemini 1.5 Flash 8B
- `gemini_1_5_flash` - Gemini 1.5 Flash
- `gemini_2_0_flash` - Gemini 2.0 Flash
- `gemini_2_0_flash_lite` - Gemini 2.0 Flash Lite
- `gemini_2_0_flash_thinking_exp_01_21` - Gemini 2.0 Flash Thinking (Experimental)
- `gemini_2_5_flash` - Gemini 2.5 Flash

## License

MIT License

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## Links

- [Google Gemini API Documentation](https://ai.google.dev/docs)
- [V Language Documentation](https://vlang.io/)