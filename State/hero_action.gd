class_name HeroAction

enum { IDLE = 0, TRAVEL = 17 }

var type: int
var progress: float
var description: String
# Optional data goes here
var meta: Dictionary = {}


# is_boss - undocumented attribute for PVE mode (only?)
# data - attribute for PVP mode (only?)
func set_from_json(value: Dictionary):
	type = value.get("type")
	progress = value.get("percents")
	description = value.get("description")
	meta = {"is_boss": value.get("is_boss"), "info_link": value.get("info_link"), "data": value.get("data")}
