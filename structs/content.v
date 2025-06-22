module structs

pub struct Content {
pub mut:
	role  Roles  @[json: role]
	parts []Part @[json: parts]
}
