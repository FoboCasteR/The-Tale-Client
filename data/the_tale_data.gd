extends Node

# https://the-tale.org/guide/api

export(String, FILE, "*.json") var path_to_enums
export(String, FILE, "*.json") var path_to_linguistics

var enums: Dictionary
var linguistics: Dictionary


func _ready():
	var f := File.new()

	f.open(path_to_enums, File.READ)
	enums = parse_json(f.get_as_text())
	f.close()

	f.open(path_to_linguistics, File.READ)
	linguistics = parse_json(f.get_as_text())
	f.close()
