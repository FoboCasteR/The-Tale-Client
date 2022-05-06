extends HBoxContainer

var attribute_value: float setget set_attribute_value


func set_attribute_value(value: float):
	attribute_value = value
	$ValueLabel.text = str(attribute_value)
