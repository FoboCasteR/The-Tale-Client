extends Control


func _on_LogoutButton_pressed():
	yield(TheTaleAPI.logout(), "completed")
	get_tree().change_scene("res://Main.tscn")
