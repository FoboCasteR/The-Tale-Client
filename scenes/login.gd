extends CenterContainer

export(NodePath) onready var email_edit_node = get_node(email_edit_node)
export(NodePath) onready var password_edit_node = get_node(password_edit_node)
export(NodePath) onready var submit_button_node = get_node(submit_button_node)


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

	var response = yield($TheTaleAPI.login(email_edit_node.text, password_edit_node.text), "completed")

	if response.is_success() and response.body.get("status") == "ok":
		GameConfig.recent_email = email_edit_node.text

		var app_name: String = ProjectSettings.get_setting("application/config/name")
		OS.set_window_title("%s - %s" % [app_name, response.body.get("data").get("account_name")])

		var account_data = response.body.get("data")
		var account = Account.new()
		account.id = account_data.get("account_id")
		account.name = account_data.get("account_name")
		account.session_expires_at = account_data.get("session_expire_at")
		account.session_id = response.cookies().get("sessionid").value

		var account_manager = AccountsManager.new()
		account_manager.add_account(account)

		EventBus.emit_signal("account_changed", account)
		get_tree().change_scene("res://scenes/game.tscn")
	else:
		submit_button_node.disabled = false


func _on_BackButton_pressed():
	get_tree().change_scene("res://scenes/accounts.tscn")
