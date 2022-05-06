extends Node
# https://the-tale.org/guide/api

var enums: Dictionary
var linguistics: Dictionary


func _ready():
	var f := File.new()

	f.open("res://Data/TheTaleEnums.json", File.READ)
	enums = parse_json(f.get_as_text())
	f.close()

	f.open("res://Data/TheTaleLinguistics.json", File.READ)
	linguistics = parse_json(f.get_as_text())
	f.close()
