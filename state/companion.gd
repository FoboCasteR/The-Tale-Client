class_name Companion

var present: bool = false

var name: String
var type: int

var coherence: int
var real_coherence: int
var xp: int
var xp_to_level: int

var health: int
var max_health: int


func set_from_json(value: Dictionary):
	type = value.get("type")
	name = value.get("name")

	coherence = value.get("coherence")
	real_coherence = value.get("real_coherence")
	xp = value.get("experience")
	xp_to_level = value.get("experience_to_level")

	health = value.get("health")
	max_health = value.get("max_health")
