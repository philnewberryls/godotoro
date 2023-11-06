extends Button
class_name ModeButton


signal mode_change_requested()

@export var is_active_mode: bool = false


func _ready():
	button_up.connect(_react_to_press)


func _react_to_press():
	get_tree().call_group("mode_buttons", "deactivate")
	is_active_mode = true
	get_tree().call_group("mode_buttons", "update_appearences")
	mode_change_requested.emit(self.name)


func deactivate():
	is_active_mode = false


func update_appearences(): 
	if is_active_mode: theme_type_variation = "ActiveMode"
	else: theme_type_variation = "InactiveMode"


func hide_if_inactive(): 
	if not is_active_mode: self.hide()

