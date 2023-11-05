extends CenterContainer
class_name TimerInterface

enum button_display_states{
	TIMER_READY,
	TIMER_IN_PROGRESS
}

signal start_button_pressed()
signal timer_pause_requested()
signal timer_resume_requested()
signal timer_reset_requested()

@export var timer_display: Label
@export var timer_stopped_buttons: HBoxContainer
@export var timer_in_progress_buttons: HBoxContainer

var default_time_to_display_in_seconds: int = 60 * 25 # Overriden from main

func _on_start_button_button_up():
	start_button_pressed.emit()
	_switch_displayed_buttons(button_display_states.TIMER_IN_PROGRESS)


func _on_pause_resume_button_timer_pause_requested():
	timer_pause_requested.emit()


func _on_pause_resume_button_timer_resume_requested():
	timer_resume_requested.emit()
	

func _on_reset_timer_button_button_up():
	timer_reset_requested.emit()
	_switch_displayed_buttons(button_display_states.TIMER_READY)
	update_timer_display(default_time_to_display_in_seconds)


func update_timer_display(time_left: float):
	var time_as_int: int = int(time_left)
	var minutes_left: int = floor(time_as_int / 60)
	var seconds_left: int = time_as_int - (minutes_left * 60)
	var time_to_display: String = str(minutes_left) + ":" + str(seconds_left)
	timer_display.text = time_to_display


func announce_timer_finished():
	pass


func _switch_displayed_buttons(state_to_switch_to: button_display_states):
	match state_to_switch_to:
		button_display_states.TIMER_READY:
			timer_in_progress_buttons.hide()
			timer_stopped_buttons.show()
		button_display_states.TIMER_IN_PROGRESS:
			timer_stopped_buttons.hide()
			timer_in_progress_buttons.show()
		_:
			printerr("Invalid state switch request given!")

