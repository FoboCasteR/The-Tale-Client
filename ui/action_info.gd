extends Control

export(NodePath) onready var description_label = get_node(description_label)
export(NodePath) onready var info_button = get_node(info_button)
export(NodePath) onready var progress_bar = get_node(progress_bar)

var url: String


func _ready():
	GameState.connect("action_changed", self, "_on_action_changed")


func _exit_tree():
	GameState.disconnect("action_changed", self, "_on_action_changed")


func _on_action_changed(action: HeroAction):
	description_label.text = Utils.upcase_first(action.description)
	progress_bar.value = action.progress * 100

	if action.meta.get("info_link"):
		info_button.visible = true
		url = TheTaleAPI.BASE_URL + action.meta.get("info_link")
	else:
		info_button.visible = false
		url = ""


func _on_InfoLinkButton_pressed():
	OS.shell_open(url)
