module structs

pub struct KeyEmptyError {
	Error
}

pub struct KeySequenceError {
	Error
}

pub struct InvalidPayloadError {
	Error
}

pub struct ExceededQuotaError {
	Error
}

pub struct ModelOverloadedError {
	Error
}

pub struct UnknownResponseError {
	Error
}

fn (err KeyEmptyError) msg() string {
	return 'Invalid Key is empty string'
}

fn (err KeySequenceError) msg() string {
	return 'Invalid Key starts with invalid sequence'
}

fn (err InvalidPayloadError) msg() string {
	return 'Model received invalid JSON payload (code 400)'
}

fn (err ExceededQuotaError) msg() string {
	return 'Exceeded current quota for model (code 429)'
}

fn (err ModelOverloadedError) msg() string {
	return 'Model is overloaded (code 503)'
}

fn (err UnknownResponseError) msg() string {
	return 'Unknown model response error (code != 200)'
}
