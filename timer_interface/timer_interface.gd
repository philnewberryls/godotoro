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


func _ready(): 
	gui.reset_setup_fields()


func _process(_delta):
	if not active_timer.is_stopped():
		gui.update_timer_display(active_timer.time_left)


func _on_active_timer_timeout():
	audio_player.play(0.0)
	gui.announce_timer_finished()


func _on_gui_new_timer_start_requested(minutes: int, seconds: int):
	var time_to_run_in_seconds: int = (minutes * 60) + seconds
	active_timer.start(time_to_run_in_seconds)


func _on_gui_timer_pause_requested():
	active_timer.paused = true


func _on_gui_timer_reset_requested():
	active_timer.stop()


func _on_gui_timer_resume_requested():
	active_timer.paused = false
