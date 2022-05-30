extends Control

export(NodePath) onready var name_label = get_node(name_label)
export(NodePath) onready var physical_power_label = get_node(physical_power_label)
export(NodePath) onready var magical_power_label = get_node(magical_power_label)
export(NodePath) onready var integrity_label = get_node(integrity_label)
export(Array, Color) var rarity_colors = [Color.white, Color.dodgerblue, Color.blueviolet]
export(Array, Color) var integrity_colors = [Color.white, Color.orange, Color.orangered, Color.red]

var artifact: Artifact setget set_artifact


func set_artifact(value: Artifact):
	artifact = value
	call_deferred("update_ui")


func update_ui():
	name_label.text = artifact.name
	name_label.add_color_override("font_color", rarity_colors[artifact.rarity])

	if artifact.is_equipment:
		physical_power_label.text = str(artifact.physical_power)
		magical_power_label.text = str(artifact.magical_power)

		var integrity_percent = floor(float(artifact.integrity) / artifact.max_integrity * 10000) / 100
		integrity_label.text = "%.*f%%" % [2 if integrity_percent < 100 else 0, integrity_percent]
		integrity_label.add_color_override("font_color", integrity_color(integrity_percent))

		var tooltip_items = PoolStringArray(
			[
				TheTaleData.enums.artifact_type.get(str(artifact.type)),
				"Прочность: %d / %d" % [artifact.integrity, artifact.max_integrity],
				"Полезность: %s" % artifact.rating
			]
		)

		var bonuses = PoolStringArray()

		if artifact.has_effect():
			bonuses.append(TheTaleData.enums.artifact_effect.get(str(artifact.effect)))
		if artifact.has_special_effect():
			bonuses.append(TheTaleData.enums.artifact_effect.get(str(artifact.special_effect)))

		if not bonuses.empty():
			tooltip_items.append("Бонус: %s" % bonuses.join(", "))

		hint_tooltip = tooltip_items.join("\n")


func integrity_color(percent: float):
	var i = 0

	if percent < 90:
		i = 1
	elif percent < 83:
		i = 2
	elif percent < 80:
		i = 3

	return integrity_colors[i]
