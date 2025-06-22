module structs

pub struct Candidate {
pub:
	content        Content        @[json: content]
	finish_reason  string         @[json: finishReason]
	index          int            @[json: index]
	safety_ratings []SafetyRating @[json: safetyRatings]
}
