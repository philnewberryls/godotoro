extends CenterContainer
class_name TimerInterface


enum button_display_states{
	TIMER_READY,
	TIMER_IN_PROGRESS
}

signal new_timer_start_requested()
signal timer_pause_requested()
signal timer_resume_requested()
signal timer_reset_requested()

@export var timer_stopped_buttons: HBoxContainer
@export var timer_in_progress_buttons: HBoxContainer
@export var timer_setup_fields: HBoxContainer
@export var timer_setup_minutes: SpinBox
@export var timer_setup_seconds: SpinBox
@export var timer_display: Label

var default_time_to_display_in_seconds: int = 60 * 25


func _on_start_button_button_up():
	new_timer_start_requested.emit(timer_setup_minutes.value, timer_setup_seconds.value)
	_switch_displayed_buttons(button_display_states.TIMER_IN_PROGRESS)


func _on_pause_resume_button_timer_pause_requested():
	timer_pause_requested.emit()


func _on_pause_resume_button_timer_resume_requested():
	timer_resume_requested.emit()
	

func _on_reset_timer_button_button_up():
	timer_reset_requested.emit()
	_switch_displayed_buttons(button_display_states.TIMER_READY)
	update_setup_fields(default_time_to_display_in_seconds)


func update_setup_fields(time_total_in_seconds: float):
	var time_total: int = floor(time_total_in_seconds)
	timer_setup_minutes.value = time_total / 60
	timer_setup_seconds.value = time_total - (timer_setup_minutes.value * 60)


func update_timer_display(time_left: float):
	var time_to_display = _convert_float_to_clock_display(time_left)
	timer_display.text = time_to_display


func announce_timer_finished():
	pass


func _convert_float_to_clock_display(time_to_convert: float) -> String:
	var seconds_total: int = floor(time_to_convert)
	var minutes_left: int = floor(seconds_total / 60)
	var seconds_left: int = int(seconds_total) - (minutes_left * 60)
	var minutes_string: String = str(minutes_left)
	var seconds_string: String = str("%0*d" % [2, seconds_left]) # Adds extra 0 if less than 10
	var result: String = str(minutes_string + ":" + seconds_string)
	return result


func _switch_displayed_buttons(state_to_switch_to: button_display_states):
	match state_to_switch_to:
		button_display_states.TIMER_READY:
			timer_in_progress_buttons.hide()
			timer_display.hide()
			timer_stopped_buttons.show()
			timer_setup_fields.show()
		button_display_states.TIMER_IN_PROGRESS:
			timer_stopped_buttons.hide()
			timer_setup_fields.hide()
			timer_in_progress_buttons.show()
			timer_display.show()
		_:
			printerr("Invalid state switch request given!")

