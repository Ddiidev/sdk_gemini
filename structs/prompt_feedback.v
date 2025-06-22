module structs

pub struct PromptFeedback {
pub:
	safety_ratings []SafetyRating @[json: safetyRatings]
}
