extends Control

export(NodePath) onready var description_label = get_node(description_label)
export(NodePath) onready var progress_bar = get_node(progress_bar)


func _ready():
	EventBus.connect("action_changed", self, "_on_action_changed")


func _exit_tree():
	EventBus.disconnect("action_changed", self, "_on_action_changed")


func _on_action_changed(action: HeroAction):
	description_label.clear()
	description_label.add_text(Utils.upcase_first(action.description))

	if action.meta.get("is_boss"):
		description_label.add_text(" ★")

	if action.meta.get("info_link"):
		description_label.add_text(" ")
		description_label.push_meta(TheTaleAPI.BASE_URL + action.meta.get("info_link"))
		description_label.add_text("?")
		description_label.pop()
		# ★

	progress_bar.value = action.progress * 100


func _on_DescriptionLabel_meta_clicked(meta):
	OS.shell_open(meta)
