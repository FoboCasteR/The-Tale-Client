extends Label


func _ready():
	EventBus.connect("turn_changed", self, "_turn_changed")


func _exit_tree():
	EventBus.disconnect("turn_changed", self, "_turn_changed")


func _turn_changed(turn: Turn):
	text = turn.time + " " + turn.date
