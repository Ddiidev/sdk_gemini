module structs

pub struct KeyEmptyError {
	Error
}

pub struct KeySequenceError {
	Error
}

fn (err KeyEmptyError) msg() string {
	return 'Invalid Key is empty string'
}

fn (err KeySequenceError) msg() string {
	return 'Invalid Key starts with invalid sequence'
}
