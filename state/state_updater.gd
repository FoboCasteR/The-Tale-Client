extends Node

var client_turns := []


func _ready():
	$TheTaleAPI.session_id = GameState.account.session_id
	EventBus.connect("turn_changed", self, "_on_turn_changed")
	EventBus.connect("quest_choice_made", self, "_on_quest_choice_made")
	request_data()


func _exit_tree():
	EventBus.disconnect("turn_changed", self, "_on_turn_changed")
	EventBus.disconnect("quest_choice_made", self, "_on_quest_choice_made")


func request_data():
	var response = yield($TheTaleAPI.game_info("", client_turns), "completed")

	if response.is_success() and response.body.get("status") == "ok":
		if not response.body.get("account", {}).get("is_old"):
			EventBus.emit_signal("server_state_updated", response.body.get("data"))

	$RequestTimer.start()


func _on_turn_changed(turn: Turn):
	client_turns.append(turn.get("number"))

	if client_turns.size() > 2:
		client_turns = client_turns.slice(1, 2)


func _on_quest_choice_made(choice: Quest.Choice):
	$TheTaleAPI.choose(choice.id)


func _on_RequestTimer_timeout():
	request_data()
