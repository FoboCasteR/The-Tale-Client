extends Control

export(PackedScene) var item_scene

onready var list := $List


func _on_list_changed(artifacts: Array):
	for node in list.get_children():
		node.queue_free()

	for artifact in artifacts:
		var item_instance = item_scene.instance()
		item_instance.artifact = artifact
		list.add_child(item_instance)
