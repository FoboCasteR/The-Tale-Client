class_name JournalMessage

var timestamp: float
var time: String
var text: String
var type: String
var data: Dictionary


func set_from_json(value: Array):
	timestamp = value[0]
	time = value[1]
	text = value[2]
	data = value[4]

	if value[3]:
		type = str(value[3])
