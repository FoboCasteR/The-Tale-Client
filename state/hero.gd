class_name Hero

var alive: bool
var name: String
var race: int
var gender: int

var level: int
var xp: int
var xp_to_level: int
var skill_points: int

var health: int
var max_health: int

var money: int
var move_speed: float
var initiative: float
var physical_power: int
var magical_power: int

var might: float
var pvp_bonus: float
var influence_bonus: float


func set_from_json(value: Dictionary):
	var base_section = value.get("base")
	var secondary_section = value.get("secondary")
	var might_section = value.get("might")

	if base_section:
		alive = base_section.get("alive")
		name = base_section.get("name")
		race = base_section.get("race")
		gender = base_section.get("gender")

		level = base_section.get("level")
		xp = base_section.get("experience")
		xp_to_level = base_section.get("experience_to_level")
		skill_points = base_section.get("destiny_points")

		health = base_section.get("health")
		max_health = base_section.get("max_health")

		money = base_section.get("money")

	if secondary_section:
		var power = secondary_section.get("power")
		physical_power = power[0]
		magical_power = power[1]
		move_speed = secondary_section.get("move_speed")
		initiative = secondary_section.get("initiative")

	if might_section:
		might = might_section.get("value")
		pvp_bonus = might_section.get("pvp_effectiveness_bonus")
		influence_bonus = might_section.get("politics_power")
