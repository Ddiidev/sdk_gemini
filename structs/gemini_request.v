module structs

pub struct GeminiRequest {
pub mut:
	contents           []Content          @[json: contents]
	system_instruction ?SystemInstruction @[json: systemInstruction; omitempty]
	generation_config  GenerationConfig   @[json: generationConfig; omitempty]
	safety_settings    []SafetySetting    @[json: safetySettings; omitempty]
}
