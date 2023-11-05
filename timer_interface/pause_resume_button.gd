extends Button

signal timer_pause_requested()
signal timer_resume_requested()

func _on_toggled(switched_to_paused):
	if switched_to_paused: 
		text = "Resume"
		timer_pause_requested.emit()
	else: 
		text = "Pause"
		timer_resume_requested.emit()
