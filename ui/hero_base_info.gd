extends Control

export(NodePath) onready var level_label = get_node(level_label)
export(NodePath) onready var name_label = get_node(name_label)
export(NodePath) onready var level_up_button = get_node(level_up_button)
export(NodePath) onready var hp_bar = get_node(hp_bar)
export(NodePath) onready var xp_bar = get_node(xp_bar)
export(NodePath) onready var physical_power_attribute = get_node(physical_power_attribute)
export(NodePath) onready var magical_power_attribute = get_node(magical_power_attribute)
export(NodePath) onready var money_attribute = get_node(money_attribute)
export(NodePath) onready var might_attribute = get_node(might_attribute)


func _ready():
	GameState.connect("hero_changed", self, "_on_hero_changed")


func _exit_tree():
	GameState.disconnect("hero_changed", self, "_on_hero_changed")


func _on_hero_changed(hero: Hero):
	var level_text := str(hero.level)

	level_label.text = level_text
	name_label.text = (
		"%s, %s"
		% [hero.name, TheTaleData.enums.race_and_gender.get(str(hero.race)).get(str(hero.gender))]
	)
	level_up_button.visible = hero.skill_points > 0

	hp_bar.max_value = hero.max_health
	hp_bar.value = hero.health

	xp_bar.max_value = hero.xp_to_level
	xp_bar.value = hero.xp

	# TODO: Refactoring
	(physical_power_attribute.get_node("ValueLabel") as Label).text = str(hero.physical_power)
	(magical_power_attribute.get_node("ValueLabel") as Label).text = str(hero.magical_power)
	(money_attribute.get_node("ValueLabel") as Label).text = str(hero.money)
	(might_attribute.get_node("ValueLabel") as Label).text = str(hero.might)
	might_attribute.hint_tooltip = "PVP: +%.2f%%\nВлияние: +%.2f%%" % [hero.pvp_bonus * 100, hero.influence_bonus * 100]


func _on_LevelUpButton_pressed():
	OS.shell_open("https://the-tale.org/game/heroes/%s#hero-tab-main=attributes" % [GameState.account_id])
