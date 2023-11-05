extends CenterContainer
class_name TimerInterface

signal start_button_pressed()

@export var timer_display: Label


func _on_start_button_button_up():
	start_button_pressed.emit()


func update_timer_display(time_left: float):
	var time_as_int: int = int(time_left)
	var minutes_left: int = floor(time_as_int / 60)
	var seconds_left: int = time_as_int - (minutes_left * 60)
	var time_to_display: String = str(minutes_left) + ":" + str(seconds_left)
	timer_display.text = time_to_display


func alert_timer_finished():
	pass
