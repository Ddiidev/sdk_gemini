module structs

pub struct SafetyRating {
pub:
	category    string @[json: category]
	probability string @[json: probability]
}
