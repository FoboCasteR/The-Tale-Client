extends Control


func _on_LoadingIndicator_visibility_changed():
	if visible:
		$AnimationPlayer.play("Loading")
	else:
		$AnimationPlayer.stop(true)
