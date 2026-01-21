module structs

pub enum Models {
	gemma_3_1b_it
	gemma_3_4b_it
	gemma_3_12b_it
	gemma_3_27b_it
	gemini_2_5_flash_lite_preview_09_2025
	gemini_2_5_flash_lite
	gemini_2_5_flash
	gemini_3_0_flash_preview
}

pub fn (m Models) is_gemma() bool {
	return match m {
		.gemma_3_1b_it {
			true
		}
		.gemma_3_4b_it {
			true
		}
		.gemma_3_12b_it {
			true
		}
		.gemma_3_27b_it {
			true
		}
		else {
			false
		}
	}
}

pub fn (m Models) str() string {
	return match m {
		.gemma_3_1b_it {
			'gemma-3-1b-it'
		}
		.gemma_3_4b_it {
			'gemma-3-4b-it'
		}
		.gemma_3_12b_it {
			'gemma-3-12b-it'
		}
		.gemma_3_27b_it {
			'gemma-3-27b-it'
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
