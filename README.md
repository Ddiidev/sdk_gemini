# Gemini V SDK

A V language SDK for interacting with Google's Gemini AI API. This module provides a simple and efficient way to integrate Gemini's generative AI capabilities into your V applications.

## Features

- Support for multiple free Gemini models (2.5 Flash variants, 3.0 Flash and gemma 3 variant) - PRs welcome for paid models
- Simple prompt-based text generation
- Advanced request configuration with system instructions
- Comprehensive response handling
- Type-safe API with structured data models
- Built-in error handling

## Installation

```bash
v install Ddiidev.sdkgemini
```

OR

```bash
v install https://github.com/Ddiidev/sdk_gemini
```

## Quick Start

```v
// import Ddiidev.sdk_gemini //for install from vpm
// for install github repo
import log // built-in V module
import sdk_gemini

fn main() {
    //log level 'debug' provides full model response when errors occur
    log.set_level(.debug)

    // Read API key from environment
    api_key := sdk_gemini.get_api_key('GEMINI_API_KEY') or {
        log.error(err.msg())
        return
    }

    // Initialize the SDK with your API key
    mut sdk := sdk_gemini.new(api_key)

    // Send a simple prompt
    response := sdk.send_prompt(
        .gemini_3_0_flash_preview,
        'Tell me about João Pessoa, Paraíba',
        'You are a tour guide from Brazil, specifically from the Northeast region, João Pessoa and Paraíba state'
    ) or {
            log.error(err.msg())
            return
    }

    content := response.str()
    println(content)
}
```

## Safe Way to Get Content

Use the `GeminiResponse` iterator to safely iterate through all parts.

```v
for part in response {
	println(part)
}
```

To get all concatenated content in a single string, use `str()`:

```v
text := response.str()
if text != '' {
	println(text)
}
```

You can also directly get the last part with `last()`:

```v
last := response.last() or { '' }
if last != '' {
	println(last)
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

- `gemma_3_1b_it` - Gemma 3.1b It
- `gemma_3_4b_it` - Gemma 3.4b It
- `gemma_3_12b_it` - Gemma 3.12b It
- `gemma_3_27b_it` - Gemma 3.27b It
- `gemini_2_5_flash_lite_preview_09_2025` - Gemini 2.5 Flash Lite Preview 09 2025
- `gemini_2_5_flash_lite` - Gemini 2.5 Flash Lite
- `gemini_2_5_flash` - Gemini 2.5 Flash
- `gemini_3_0_flash_preview` - Gemini 3.0 Flash Preview

## License

MIT License

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## Links

- [Google Gemini API Documentation](https://ai.google.dev/docs)
- [V Language Documentation](https://vlang.io/)
