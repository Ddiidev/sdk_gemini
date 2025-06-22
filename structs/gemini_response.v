module structs

pub struct GeminiResponse {
pub:
	candidates      []Candidate    @[json: candidates]
	prompt_feedback PromptFeedback @[json: promptFeedback]
}
