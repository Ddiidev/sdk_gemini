module structs

pub struct PromptTokensDetail {
pub:
	modality    string @[json: modality]
	token_count int    @[json: tokenCount]
}

pub struct UsageMetadata {
pub:
	prompt_token_count   int                  @[json: promptTokenCount]
	total_token_count    int                  @[json: totalTokenCount]
	prompt_tokens_detail []PromptTokensDetail @[json: promptTokensDetails]
}

pub struct GeminiResponse {
pub:
	candidates      []Candidate    @[json: candidates]
	prompt_feedback PromptFeedback @[json: promptFeedback]
	usage_metadata  UsageMetadata  @[json: usageMetadata]
	model_version   string         @[json: modelVersion]
	response_id     string         @[json: responseId]
mut:
	idx_part int
	idx      int
}

pub fn (mut g GeminiResponse) next() ?string {
	defer {
		g.idx_part++

		if g.idx_part >= g.candidates[g.idx].content.parts.len {
			g.idx++
			g.idx_part = 0
		}
	}

	if g.idx == 0 {
		g.idx_part = 0
	}

	if g.idx + 1 > g.candidates.len || g.idx_part + 1 > g.candidates[g.idx].content.parts.len {
		g.idx = 0
		g.idx_part = 0
		return none
	}

	return g.candidates[g.idx].content.parts[g.idx_part].text
}

// str returns the response as a string.
pub fn (g GeminiResponse) str() string {
	mut result := ''

	for i, curr in g.candidates {
		for part in curr.content.parts {
			result += part.text
		}
		if i < g.candidates.len - 1 {
			result += '\n\n-\n'
		}
	}

	return result
}

// last returns the last part of the last candidate.
pub fn (g GeminiResponse) last() ?string {
	return g.candidates#[-1..][0] or { none }.content.parts#[-1..][0] or { none }.text
}
