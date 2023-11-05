extends Node

@export var timer_interface: TimerInterface
@export var active_timer: Timer
@export var audio_player: AudioStreamPlayer

@export_category("Settings")
@export var default_start_time_in_seconds: int = 60 * 25


func _ready(): 
	timer_interface.start_button_pressed.connect(_start_timer)
	timer_interface.timer_pause_requested.connect(_pause_timer)
	timer_interface.timer_resume_requested.connect(_resume_timer)

func _process(_delta):
	if not active_timer.is_stopped():
		timer_interface.update_timer_display(active_timer.time_left)


func _on_active_timer_timeout():
	audio_player.play(0.0)
	timer_interface.alert_timer_finished()


func _start_timer():
	active_timer.start(default_start_time_in_seconds)


func _pause_timer():
	active_timer.paused = true


func _resume_timer():
	active_timer.paused = false
