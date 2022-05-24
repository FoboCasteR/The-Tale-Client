extends "res://ui/artifact_info_list.gd"


func _ready():
	GameState.connect("bag_changed", self, "_on_bag_changed")


func _exit_tree():
	GameState.disconnect("bag_changed", self, "_on_bag_changed")


func _on_bag_changed(bag: Bag):
	._on_list_changed(bag.items)
