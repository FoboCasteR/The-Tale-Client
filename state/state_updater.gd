extends Node

var client_turns := []


func _ready():
	$TheTaleAPI.session_id = GameState.account.session_id
	EventBus.connect("turn_changed", self, "_on_turn_changed")
	EventBus.connect("quest_choice_made", self, "_on_quest_choice_made")
	EventBus.connect("diary_version_changed", self, "_on_diary_version_changed")
	request_game_info()


func _exit_tree():
	EventBus.disconnect("turn_changed", self, "_on_turn_changed")
	EventBus.disconnect("quest_choice_made", self, "_on_quest_choice_made")
	EventBus.disconnect("diary_version_changed", self, "_on_diary_version_changed")


func request_game_info():
	var response = yield($TheTaleAPI.game_info("", client_turns), "completed")

	if response.is_success() and response.body.get("status") == "ok":
		EventBus.emit_signal("server_state_updated", response.body.get("data"))

	$RequestTimer.start()


func _on_turn_changed(turn: Turn):
	client_turns.append(turn.get("number"))

	if client_turns.size() > 2:
		client_turns = client_turns.slice(1, 2)


func _on_quest_choice_made(choice: Quest.Choice):
	$TheTaleAPI.choose(choice.id)


func _on_diary_version_changed(_value: int):
	var response = yield($TheTaleAPI.diary(), "completed")

	if response.is_success() and response.body.get("status") == "ok":
		EventBus.emit_signal("diary_updated", response.body.get("data"))


func _on_RequestTimer_timeout():
	request_game_info()
