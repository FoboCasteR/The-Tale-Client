class_name Turn

var number: int
var date: String
var time: String


func set_from_json(value: Dictionary):
	number = value.get("number")
	date = value.get("verbose_date")
	time = value.get("verbose_time")
