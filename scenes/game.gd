extends Control

var client_turns := []


func _ready():
	GameState.connect("turn_changed", self, "_on_turn_changed")
	request_data()


func _exit_tree():
	GameState.disconnect("turn_changed", self, "_on_turn_changed")
	GameState.reset()


func request_data():
	var data = yield(TheTaleAPI.game_info("", client_turns), "completed")

	if data:
		GameState.update_state_from_dict(data)

	$RequestTimer.start()


func _on_turn_changed(turn: Turn):
	client_turns.append(turn.get("number"))

	if client_turns.size() > 2:
		client_turns = client_turns.slice(1, 2)


func _on_RequestTimer_timeout():
	request_data()


func _on_LogoutButton_pressed():
	yield(TheTaleAPI.logout(), "completed")
	get_tree().change_scene("res://main.tscn")


func _on_OpenBrowserButton_pressed():
	OS.shell_open("https://the-tale.org/game")
