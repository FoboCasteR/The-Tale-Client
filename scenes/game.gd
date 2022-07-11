extends Control


func _ready():
	var app_name: String = ProjectSettings.get_setting("application/config/name")
	var title = "%s - %s" % [app_name, GameState.account.name]

	if OS.is_debug_build():
		title += " (DEBUG)"

	OS.set_window_title(title)


func _exit_tree():
	EventBus.emit_signal("session_ended")


func _on_ChangeAccountButton_pressed():
	get_tree().change_scene("res://scenes/accounts.tscn")


func _on_OpenBrowserButton_pressed():
	OS.shell_open("https://the-tale.org/game")
