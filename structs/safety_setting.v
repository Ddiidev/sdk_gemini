module structs

pub struct SafetySetting {
pub:
	category  string @[json: category]
	threshold string @[json: threshold]
}
