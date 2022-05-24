class_name Quest

var name: String
var type: String
var experience: int
var power: int
var action: String
var actors: Array = []
var choice: String
var choices: Array = []


class Actor:
	enum TYPE { PERSON, PLACE, SPENDING }

	var title: String
	var type: int
	var data: Dictionary

	func set_from_json(value: Array):
		title = value[0]
		type = value[1]
		data = value[2]


class Choice:
	var id: String
	var description: String

	func set_from_json(value: Array):
		id = value[0]
		description = value[1]


func set_from_json(value: Dictionary):
	name = value.get("name")
	type = value.get("type")
	experience = value.get("experience")
	power = value.get("power")
	action = value.get("action")

	if typeof(value.get("choice")) == TYPE_STRING:
		choice = value.get("choice")

	for actor_data in value.get("actors"):
		var actor = Actor.new()
		actor.set_from_json(actor_data)
		actors.append(actor)

	for choice_data in value.get("choice_alternatives"):
		var choice = Choice.new()
		choice.set_from_json(choice_data)
		choices.append(choice)
