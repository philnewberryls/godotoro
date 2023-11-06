extends Node
class_name TimerInterface


enum mode_states{
	WORK,
	SHORT_BREAK,
	LONG_BREAK
}

@export var gui: TimerInterfaceGUI
@export var active_timer: Timer
@export var audio_player: AudioStreamPlayer

var current_mode: mode_states = mode_states.WORK
var pomos_until_long_break_setting: int = 4
var pomos_until_long_break_current: int = pomos_until_long_break_setting

func _ready(): 
	gui.reset_setup_fields()


func _process(_delta):
	if not active_timer.is_stopped():
		gui.update_timer_display(active_timer.time_left)


func _on_active_timer_timeout():
	audio_player.play(0.0)
	gui.announce_timer_finished()
	_progress_current_mode()


func _on_gui_new_timer_start_requested(minutes: int, seconds: int):
	var time_to_run_in_seconds: int = (minutes * 60) + seconds
	active_timer.start(time_to_run_in_seconds)


func _on_gui_timer_pause_requested():
	active_timer.paused = true


func _on_gui_timer_reset_requested():
	active_timer.stop()


func _on_gui_timer_resume_requested():
	active_timer.paused = false


func _on_skip_button_button_up():
	active_timer.start(0.1)


func _progress_current_mode():
	match current_mode:
		mode_states.WORK:
			pomos_until_long_break_current -= 1
			if pomos_until_long_break_current <= 0:
				pomos_until_long_break_current = pomos_until_long_break_setting
				current_mode = mode_states.LONG_BREAK
			else:
				current_mode = mode_states.SHORT_BREAK
		mode_states.SHORT_BREAK:
			current_mode = mode_states.WORK
		mode_states.LONG_BREAK:
			current_mode = mode_states.WORK 
	gui.show_time_input_ready_display()
