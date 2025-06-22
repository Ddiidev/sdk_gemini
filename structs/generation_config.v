module structs

pub struct GenerationConfig {
pub:
	temperature       f32      @[json: temperature; omitempty]
	top_k             int      @[json: topK; omitempty]
	top_p             f32      @[json: topP; omitempty]
	max_output_tokens int      @[json: maxOutputTokens; omitempty]
	stop_sequences    []string @[json: stopSequences; omitempty]
}
