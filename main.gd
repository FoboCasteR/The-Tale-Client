extends Node


func _ready():
	if OS.has_feature("pc"):
		OS.set_min_window_size(Vector2(800, 600))

	get_tree().change_scene("res://scenes/accounts.tscn")
