extends Node

export(PackedScene) var item_scene

onready var list := $List


func _ready():
	EventBus.connect("diary_messages_changed", self, "_on_messages_changed")


func _exit_tree():
	EventBus.disconnect("diary_messages_changed", self, "_on_messages_changed")


func _on_messages_changed(messages: Array):
	for node in list.get_children():
		node.queue_free()

	for message in messages:
		var node = item_scene.instance()
		node.message = message
		list.add_child(node)
