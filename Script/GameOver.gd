extends CanvasLayer



func _on_retry_pressed():
	get_tree().reload_current_scene()



func _on_quit_pressed():
	get_tree().quit()
