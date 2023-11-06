extends CenterContainer
class_name TimerInterfaceGUI


enum button_display_states{
	TIMER_READY,
	TIMER_IN_PROGRESS
}


signal new_timer_start_requested()
signal timer_pause_requested()
signal timer_resume_requested()
signal timer_reset_requested()

@export var timer_interface: TimerInterface
@export var timer_stopped_buttons: HBoxContainer
@export var timer_in_progress_buttons: HBoxContainer
@export var timer_setup_fields: HBoxContainer
@export var timer_setup_minutes: SpinBox
@export var timer_setup_seconds: SpinBox
@export var timer_display: Label
@export var mode_button_work: ModeButton
@export var mode_button_short_break: ModeButton
@export var mode_button_long_break: ModeButton

var default_work_time_seconds: int = 60 * 25
var default_short_break_time_seconds: int = 60 * 5
var default_long_break_seconds: int = 60 * 15


func _ready():
	for mode_button in get_tree().get_nodes_in_group("mode_buttons"):
		mode_button.mode_change_requested.connect(_on_mode_change_requested)


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
	reset_setup_fields()


func _on_mode_change_requested(mode_name: String):
	get_tree().call_group("mode_buttons", "deactivate_if_still_active")
	var intended_mode_switch: TimerInterface.mode_states
	if mode_name.to_lower().contains("work"):
		intended_mode_switch = timer_interface.mode_states.WORK
	elif mode_name.to_lower().contains("short"):
		intended_mode_switch = timer_interface.mode_states.SHORT_BREAK
	elif mode_name.to_lower().contains("long"):
		intended_mode_switch = timer_interface.mode_states.LONG_BREAK
	else:
		printerr("Invalid mode name given!")
	if intended_mode_switch == timer_interface.current_mode:
		return
	else:
		timer_interface.current_mode = intended_mode_switch
		reset_setup_fields()
		show_time_input_ready_display()


func _convert_float_to_clock_display(time_to_convert: float) -> String:
	var seconds_total: int = floor(time_to_convert)
	var minutes_left: int = int(floor(seconds_total / 60))
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
			get_tree().call_group("mode_buttons", "show")
		button_display_states.TIMER_IN_PROGRESS:
			timer_stopped_buttons.hide()
			timer_setup_fields.hide()
			timer_in_progress_buttons.show()
			timer_display.show()
			get_tree().call_group("mode_buttons", "hide_if_inactive")
		_:
			printerr("Invalid state switch request given!")


func show_time_input_ready_display():
	_switch_displayed_buttons(button_display_states.TIMER_READY)
	_switch_to_appropriate_mode_button()
	reset_setup_fields()


func _switch_to_appropriate_mode_button():
	get_tree().call_group("mode_buttons", "deactivate")
	match timer_interface.current_mode:
		timer_interface.mode_states.WORK: 
			mode_button_work.is_active_mode = true
		timer_interface.mode_states.SHORT_BREAK: 
			mode_button_short_break.is_active_mode = true
		timer_interface.mode_states.LONG_BREAK: 
			mode_button_long_break.is_active_mode = true
	get_tree().call_group("mode_buttons", "update_appearences")


func update_setup_fields(time_total_in_seconds: float):
	var time_total: int = floor(time_total_in_seconds)
	timer_setup_minutes.value = time_total / 60
	timer_setup_seconds.value = time_total - (timer_setup_minutes.value * 60)


func update_timer_display(time_left: float):
	var time_to_display = _convert_float_to_clock_display(time_left)
	timer_display.text = time_to_display


func announce_timer_finished():
	pass


func reset_setup_fields():
	match timer_interface.current_mode:
		timer_interface.mode_states.WORK:
			update_setup_fields(default_work_time_seconds)
		timer_interface.mode_states.SHORT_BREAK:
			update_setup_fields(default_short_break_time_seconds)
		timer_interface.mode_states.LONG_BREAK:
			update_setup_fields(default_long_break_seconds)
