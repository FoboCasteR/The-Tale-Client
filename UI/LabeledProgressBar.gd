extends ProgressBar

onready var is_absolute := not percent_visible setget set_is_absolute


func set_is_absolute(value: bool):
	is_absolute = value
	update_ui()


func update_ui():
	percent_visible = not is_absolute

	if is_absolute:
		$Label.text = str(value) + " / " + str(max_value)
		$Label.visible = true
	else:
		$Label.visible = false


func _on_ProgressBar_gui_input(event):
	if event is InputEventMouseButton and event.button_mask == BUTTON_LEFT:
		self.is_absolute = not is_absolute


func _on_ProgressBar_changed():
	update_ui()


func _on_ProgressBar_value_changed(_value):
	update_ui()
