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
	gui.new_timer_start_requested.connect(_start_timer)
	gui.timer_pause_requested.connect(_pause_timer)
	gui.timer_resume_requested.connect(_resume_timer)
	gui.timer_reset_requested.connect(_reset_timer)
	gui.reset_setup_fields()


func _process(_delta):
	if not active_timer.is_stopped():
		gui.update_timer_display(active_timer.time_left)


func _on_active_timer_timeout():
	audio_player.play(0.0)
	gui.announce_timer_finished()


func _start_timer(mins: int, secs: int):
	var time_to_run_in_seconds: int = (mins * 60) + secs
	active_timer.start(time_to_run_in_seconds)


func _pause_timer():
	active_timer.paused = true


func _resume_timer():
	active_timer.paused = false


func _reset_timer():
	active_timer.stop()
