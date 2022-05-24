extends Node

const CONFIG_PATH = "user://config.cfg"

var config := ConfigFile.new()
var recent_email: String setget set_recent_email, get_recent_email
var test_email: String setget , get_test_email
var test_password: String setget , get_test_password


func _ready():
	config.load(CONFIG_PATH)


func set_recent_email(value: String) -> void:
	config.set_value("ui", "recent_email", value)
	config.save(CONFIG_PATH)


func get_recent_email() -> String:
	return config.get_value("ui", "recent_email", "")


func get_test_email() -> String:
	return config.get_value("test", "email", "")


func get_test_password() -> String:
	return config.get_value("test", "password", "")
