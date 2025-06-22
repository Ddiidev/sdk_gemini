module structs

pub enum Models {
	gemini_1_5_flash_8b
	gemini_1_5_flash
	gemini_2_0_flash
	gemini_2_0_flash_lite
	gemini_2_0_flash_thinking_exp_01_21
	gemini_2_5_flash
}

pub fn (m Models) str() string {
	return match m {
		.gemini_1_5_flash_8b {
			'gemini-1.5-flash-8b'
		}
		.gemini_1_5_flash {
			'gemini-1.5-flash'
		}
		.gemini_2_0_flash {
			'gemini-2.0-flash'
		}
		.gemini_2_0_flash_lite {
			'gemini-2.0-flash-lite'
		}
		.gemini_2_0_flash_thinking_exp_01_21 {
			'gemini-2.0-flash-thinking-exp-01-21'
		}
		.gemini_2_5_flash {
			'gemini-2.5-flash'
		}
	}
}
