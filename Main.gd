extends Node


func _ready():
	var data = yield(TheTaleAPI.info(), "completed")
	var app_name: String = ProjectSettings.get_setting("application/config/name")

	if data and data.get("account_id"):
		OS.set_window_title("%s - %s" % [app_name, data.get("account_name")])

		get_tree().change_scene("res://GameInfo.tscn")
	else:
		OS.set_window_title(app_name)

		get_tree().change_scene("res://Login.tscn")
