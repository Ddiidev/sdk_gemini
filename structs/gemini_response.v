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
}
