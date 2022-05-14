extends CenterContainer

export(NodePath) onready var email_edit_node = get_node(email_edit_node)
export(NodePath) onready var password_edit_node = get_node(password_edit_node)
export(NodePath) onready var submit_button_node = get_node(submit_button_node)

var game_info_scene := preload("res://GameInfo.tscn")


func _ready():
	if not GameConfig.test_email.empty():
		email_edit_node.text = GameConfig.test_email
		password_edit_node.text = GameConfig.test_password

		submit_button_node.grab_focus()
	elif not GameConfig.recent_email.empty():
		email_edit_node.text = GameConfig.recent_email

		password_edit_node.grab_focus()
	else:
		email_edit_node.grab_focus()


func _on_SubmitButton_pressed():
	submit_button_node.disabled = true

	var data = yield(TheTaleAPI.login(email_edit_node.text, password_edit_node.text, false), "completed")

	submit_button_node.disabled = false

	if data and data.get("account_id"):
		GameConfig.recent_email = email_edit_node.text

		var app_name: String = ProjectSettings.get_setting("application/config/name")
		OS.set_window_title("%s - %s" % [app_name, data.get("account_name")])

		get_tree().change_scene_to(game_info_scene)
