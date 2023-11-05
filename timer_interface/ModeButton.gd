extends Button
class_name ModeButton

signal mode_change_requested()

@export var is_active_mode: bool = false : 
	set(value): 
		is_active_mode = value
		if is_active_mode: 
			self.theme_type_variation = "ActiveMode"
			mode_change_requested.emit(self.name)
		else: 
			self.theme_type_variation = "InactiveMode"


func _ready():
	button_up.connect(_react_to_press)


func _react_to_press():
	get_tree().call_group("mode_buttons", "return_to_default_state")
	is_active_mode = true
	

func return_to_default_state():
	is_active_mode = false


func hide_if_inactive(): 
	if not is_active_mode: self.hide()
