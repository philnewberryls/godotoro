extends Node

@export var timer_interface: TimerInterface
@export var active_timer: Timer
@export var audio_player: AudioStreamPlayer


func _ready(): 
	timer_interface.new_timer_start_requested.connect(_start_timer)
	timer_interface.timer_pause_requested.connect(_pause_timer)
	timer_interface.timer_resume_requested.connect(_resume_timer)
	timer_interface.timer_reset_requested.connect(_reset_timer)
	timer_interface.reset_setup_fields()


func _process(_delta):
	if not active_timer.is_stopped():
		timer_interface.update_timer_display(active_timer.time_left)


func _on_active_timer_timeout():
	audio_player.play(0.0)
	timer_interface.announce_timer_finished()


func _start_timer(mins: int, secs: int):
	var time_to_run_in_seconds: int = (mins * 60) + secs
	active_timer.start(time_to_run_in_seconds)


func _pause_timer():
	active_timer.paused = true


func _resume_timer():
	active_timer.paused = false


func _reset_timer():
	active_timer.stop()
