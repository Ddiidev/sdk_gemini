module tests

import json
import structs

const json_value_5_content = '
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "x is 2\n"
          }
        ],
        "role": "model"
      },
      "finishReason": "STOP",
      "index": 0
    },
    {
      "content": {
        "parts": [
          {
            "text": "x equals 2\n"
          }
        ],
        "role": "model"
      },
      "finishReason": "STOP",
      "index": 1
    },
    {
      "content": {
        "parts": [
          {
            "text": "The value of x "
          },
          {
            "text": "is 2.\n"
          },
		  {
		  	"text": "no other values"
		  }
        ],
        "role": "model"
      },
      "finishReason": "MAX_TOKENS",
      "index": 2
    }
  ]
}'

const json_value_one_part = '
{
	"candidates": [
		{
			"content": {
				"parts": [
					{
						"text": "x is 2\n"
					}
				],
				"role": "model"
			},
			"finishReason": "STOP",
			"index": 0
		}
	]
}
'

const json_value_empty = '
{
  "candidates": [
    {
      "content": {
        "parts": [],
        "role": "model"
      },
      "finishReason": "STOP",
      "index": 0
    }
  ]
}'

fn test_safe_get_content_empty() {
	resp := json.decode(structs.GeminiResponse, json_value_empty)!

	assert resp.str().replace('\n', '').len_utf8() == 0
}

fn test_safe_get_content_not_empty() {
	resp := json.decode(structs.GeminiResponse, json_value_one_part)!

	assert resp.str().replace('\n', '') == 'x is 2'
}

fn test_safe_get_content_iterator() {
	mut resp := json.decode(structs.GeminiResponse, json_value_5_content)!

	mut comparer_resp := {
		0: resp.candidates[0].content.parts[0].text
		1: resp.candidates[1].content.parts[0].text
		2: resp.candidates[2].content.parts[0].text
		3: resp.candidates[2].content.parts[1].text
		4: resp.candidates[2].content.parts[2].text
	}
	for i, content in resp {
		assert content == comparer_resp[i]
	}
}

fn test_safe_get_content_iterator_double_run() {
	mut resp := json.decode(structs.GeminiResponse, json_value_5_content)!

	mut comparer_resp := {
		0: resp.candidates[0].content.parts[0].text
		1: resp.candidates[1].content.parts[0].text
		2: resp.candidates[2].content.parts[0].text
		3: resp.candidates[2].content.parts[1].text
		4: resp.candidates[2].content.parts[2].text
	}
	for i, content in resp {
		assert content == comparer_resp[i]
	}

	for i, content in resp {
		assert content == comparer_resp[i]
	}
}

fn test_safe_get_content_last() {
	resp := json.decode(structs.GeminiResponse, json_value_5_content)!
	last := resp.last() or {
		assert false
		return
	}
	assert last == 'no other values'
}

fn test_safe_get_content_empty_last() {
	resp := json.decode(structs.GeminiResponse, json_value_empty)!
	last := resp.last()
	assert last == none
}
