module main

import sdk_gemini
import sdk_gemini.structs
import time
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

pub struct Spinner {
	set  []string
	done chan bool
mut:
	run bool
}

fn main() {
	log.set_level(.error)

	help_string := ':q to exit | :w write to file'

	conf := ReplConfig{
		model:    .gemini_2_5_flash
		tui_user: '> '
		tui_llm:  ''
		file_out: 'gemini_response.md'
	}

	shared spin := Spinner{
		set: ['.', '..', '...', ' ']
	}

	mut repl := ReplState{}

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
				spin.start()
				repl.response_buffer = get_response(mut sdk, conf, mut repl) or {
					spin.stop()
					log.error(err.msg())
					exit(1)
				}
				spin.stop()
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

pub fn (shared s Spinner) start() {
	lock s {
		s.run = true
	}
	// hides cursor
	print('\033[?25l')
	flush_stdout()
	go fn [shared s] () {
		for {
			if s.run {
				for v in s.set {
					print(v)
					flush_stdout()
					time.sleep(200 * time.millisecond)
					// erase current line  and reset cursor to start of current line
					print('\033[K\r')
					flush_stdout()
				}
			} else {
				print('\033[K\r')
				flush_stdout()
				// makecursor visible
				print('\033[?25h')
				flush_stdout()
				s.done <- true
				return
			}
		}
	}()
}

pub fn (shared s Spinner) stop() {
	lock s {
		s.run = false
	}
	select {
		_ := <-s.done {
			return
		}
	}
}
