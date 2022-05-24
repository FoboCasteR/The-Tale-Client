class_name Artifact

const NO_EFFECT = 666

var type: int
var name: String
var is_equipment: bool
var rarity: int
var rating: float

var integrity: int
var max_integrity: int

var physical_power: int
var magical_power: int

var effect: int
var special_effect: int


func has_effect() -> bool:
	return effect != NO_EFFECT


func has_special_effect() -> bool:
	return special_effect != NO_EFFECT


func set_from_json(value: Dictionary):
	type = value.get("type")
	name = value.get("name")
	is_equipment = value.get("equipped")

	if is_equipment:
		rarity = value.get("rarity")
		effect = value.get("effect")
		special_effect = value.get("special_effect")
		rating = value.get("preference_rating")

		var integrity_data = value.get("integrity")
		if integrity_data and integrity_data[1]:
			integrity = integrity_data[0]
			max_integrity = integrity_data[1]

		var power = value.get("power")
		if power:
			physical_power = power[0]
			magical_power = power[1]
