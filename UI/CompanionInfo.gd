extends Control

export(NodePath) onready var coherence_label = get_node(coherence_label)
export(NodePath) onready var name_label = get_node(name_label)
export(NodePath) onready var hp_bar = get_node(hp_bar)
export(NodePath) onready var xp_bar = get_node(xp_bar)


func _ready():
	GameState.connect("companion_changed", self, "_on_companion_changed")


func _exit_tree():
	GameState.disconnect("companion_changed", self, "_on_companion_changed")


func _on_companion_changed(companion: Companion):
	if companion.present:
		visible = true

		coherence_label.text = str(companion.coherence)
		name_label.text = companion.name

		hp_bar.max_value = companion.max_health
		hp_bar.value = companion.health

		xp_bar.max_value = companion.xp_to_level
		xp_bar.value = companion.xp
	else:
		visible = false
