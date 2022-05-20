extends Node


func _ready():
	if OS.has_feature("pc"):
		OS.set_min_window_size(Vector2(800, 600))

	print(OS.get_user_data_dir())

	var data = yield(TheTaleAPI.info(), "completed")
	var app_name: String = ProjectSettings.get_setting("application/config/name")

	if data and data.get("account_id"):
		OS.set_window_title("%s - %s" % [app_name, data.get("account_name")])

		get_tree().change_scene("res://overview.tscn")
	else:
		OS.set_window_title(app_name)

		get_tree().change_scene("res://login.tscn")
