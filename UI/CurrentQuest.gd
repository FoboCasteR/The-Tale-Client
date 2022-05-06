extends VBoxContainer


func _ready():
	GameState.connect("quests_changed", self, "_on_quests_changed")


func _exit_tree():
	GameState.disconnect("quests_changed", self, "_on_quests_changed")


func _on_quests_changed(quests: Array):
	var current_quest = quests.back()
	$Quest.quest = current_quest

	# TODO: Rewrite
	if current_quest.choices.size():
		$Menu.visible = true
		$Menu.disabled = false
		$Menu.text = current_quest.choice if current_quest.choice else "Выбрать поступок"

		for choice in current_quest.choices:
			$Menu.get_popup().add_item(choice.description)
	else:
		$Menu.get_popup().clear()

		if current_quest.choice.empty():
			$Menu.visible = false
		else:
			$Menu.visible = true
			$Menu.disabled = true
			$Menu.text = current_quest.choice
