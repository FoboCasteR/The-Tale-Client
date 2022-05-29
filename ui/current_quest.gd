extends VBoxContainer

onready var menu_button = $Menu


func _ready():
	GameState.connect("quests_changed", self, "_on_quests_changed")
	menu_button.get_popup().connect("id_pressed", self, "_on_choice_made")


func _exit_tree():
	GameState.disconnect("quests_changed", self, "_on_quests_changed")


func _on_quests_changed(quests: Array):
	var current_quest = quests.back()
	$Quest.quest = current_quest

	# TODO: Rewrite
	menu_button.get_popup().clear()

	if current_quest.choices.size():
		menu_button.visible = true
		menu_button.disabled = false
		menu_button.text = current_quest.choice if current_quest.choice else "Выбрать поступок"

		for i in current_quest.choices.size():
			var choice = current_quest.choices[i]
			menu_button.get_popup().add_item(choice.description, i)
	else:
		if current_quest.choice.empty():
			menu_button.visible = false
		else:
			menu_button.visible = true
			menu_button.disabled = true
			menu_button.text = current_quest.choice


func _on_choice_made(id: int):
	# TODO: Rewrite
	var choice = GameState.quests.back().choices[id]

	TheTaleAPI.choose(choice.id)

	menu_button.disabled = true
	menu_button.text = choice.description
