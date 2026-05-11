module tests

import sdkgemini
import structs
import os

fn test_get_api_key_not_exist() ! {
	got := sdkgemini.get_api_key('NOT_EXIST') or {
		if err is structs.KeyEmptyError {
			return
		} else {
			return err
		}
	}
}

fn test_get_api_key_invalid() ! {
	key := 'abcd0123456789'
	os.setenv('MOCK_API_KEY', key, true)
	got := sdkgemini.get_api_key('MOCK_API_KEY') or {
		if err is structs.KeySequenceError {
			return
		} else {
			return err
		}
	}
}

fn test_get_api_key_valid() ! {
	key := 'AIza0123456789'
	os.setenv('MOCK_API_KEY', key, true)
	got := sdkgemini.get_api_key('MOCK_API_KEY') or { return err }
	assert got == key
}

fn test_new() ! {
	key := 'AIza0123456789'
	got := sdkgemini.new(key)
	assert got == sdkgemini.GeminiSDK{
		api_key: key
	}
}
