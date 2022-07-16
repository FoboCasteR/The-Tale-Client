class_name DiaryMessage

var data: Dictionary
var date: String
var message: String
var position: String
var time: String
var timestamp: int
var type: String


func set_from_json(value: Dictionary):
	data = value.get("variables")
	date = value.get("game_date")
	message = value.get("message")
	position = value.get("position")
	time = value.get("game_time")
	timestamp = value.get("timestamp")

	if value.get("type"):
		type = str(value.get("type"))
