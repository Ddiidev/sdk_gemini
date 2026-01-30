module main

import sdk_gemini
import sdk_gemini.structs
import log
import os

struct ReplConfig {
	model    structs.Models
	tui_user string
	tui_llm  string
mut:
	file_out string
}

struct ReplState {
mut:
	user_prompt        string
	system_instruction string
	response_buffer    string
}

fn main() {
	help_string := ':q to exit | :w write to file'

	conf := ReplConfig{
		model:    .gemini_2_5_flash
		tui_user: '> '
		tui_llm:  ''
		file_out: 'gemini_response.md'
	}

	mut repl := ReplState{}

	log.set_level(.debug)

	api_key := sdk_gemini.get_api_key('GEMINI_API_KEY') or {
		log.error(err.msg())
		return
	}

	mut sdk := sdk_gemini.new(api_key)

	for {
		repl.user_prompt = os.input(conf.tui_user)

		match repl.user_prompt {
			'?' {
				print_response(conf, help_string)
			}
			'h' {
				print_response(conf, help_string)
			}
			':h' {
				print_response(conf, help_string)
			}
			'help' {
				print_response(conf, help_string)
			}
			':w' {
				write_response_buffer(conf, repl) or {
					log.error(err.msg())
					continue
				}
				print_response(conf, 'writing response buffer to ${conf.file_out}')
			}
			':q' {
				exit(0)
			}
			'' {
				continue
			}
			else {
				repl.response_buffer = get_response(mut sdk, conf, mut repl) or {
					log.error(err.msg())
					continue
				}
				print_response(conf, repl.response_buffer)
			}
		}
	}
}

fn get_response(mut sdk sdk_gemini.GeminiSDK, conf ReplConfig, mut repl ReplState) !string {
	mut output := ''
	response := sdk.send_prompt(conf.model, repl.user_prompt, repl.system_instruction) or {
		return err
	}
	for part in response {
		output += part
	}
	return output
}

fn print_response(conf ReplConfig, msg string) {
	println(conf.tui_llm + msg)
}

fn write_response_buffer(conf ReplConfig, repl ReplState) ! {
	os.write_file(conf.file_out, repl.response_buffer) or { return err }
}
