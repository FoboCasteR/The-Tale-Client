extends ScrollContainer

export(PackedScene) var item_scene

onready var list := $List


func _ready():
	GameState.connect("quests_changed", self, "_on_quests_changed")


func _exit_tree():
	GameState.disconnect("quests_changed", self, "_on_quests_changed")


func _on_quests_changed(quests: Array):
	for node in list.get_children():
		node.queue_free()

	for quest in quests:
		var node = item_scene.instance()
		node.quest = quest
		list.add_child(node)
