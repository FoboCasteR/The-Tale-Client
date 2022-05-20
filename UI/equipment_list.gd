extends "res://ui/artifact_info_list.gd"


func _ready():
	GameState.connect("equipment_changed", self, "_on_list_changed")


func _exit_tree():
	GameState.disconnect("equipment_changed", self, "_on_list_changed")
