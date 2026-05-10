module structs

pub enum Models {
	gemma_4_26b_a4b_it
	gemma_4_31b_it
	gemini_2_5_flash_lite_preview_09_2025
	gemini_2_5_flash_lite
	gemini_2_5_flash
	gemini_3_0_flash_preview
}

pub fn (m Models) is_gemma() bool {
	return match m {
		.gemma_4_26b_a4b_it {
			true
		}
		.gemma_4_31b_it {
			true
		}
		else {
			false
		}
	}
}

pub fn (m Models) str() string {
	return match m {
		.gemma_4_26b_a4b_it {
			'gemma-4-26b-a4b-it'
		}
		.gemma_4_31b_it {
			'gemma-4-31b-it'
		}
		.gemini_2_5_flash_lite_preview_09_2025 {
			'gemini-2.5-flash-lite-preview-09-2025'
		}
		.gemini_2_5_flash_lite {
			'gemini-2.5-flash-lite'
		}
		.gemini_2_5_flash {
			'gemini-2.5-flash'
		}
		.gemini_3_0_flash_preview {
			'gemini-3-flash-preview'
		}
	}
}
