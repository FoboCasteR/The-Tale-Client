extends Control

export(NodePath) onready var name_label = get_node(name_label)
export(NodePath) onready var physical_power_label = get_node(physical_power_label)
export(NodePath) onready var magical_power_label = get_node(magical_power_label)
export(Array, Color) var rarity_colors

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
