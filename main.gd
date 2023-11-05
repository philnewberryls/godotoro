extends Node


@export var timer_interface: TimerInterface
@export var active_timer: Timer


func _ready(): 
	timer_interface.start_button_pressed.connect(start_timer)


func _process(_delta):
	if not active_timer.is_stopped():
		timer_interface.update_timer_display(active_timer.time_left)

func start_timer():
	active_timer.start(60 * 25)
