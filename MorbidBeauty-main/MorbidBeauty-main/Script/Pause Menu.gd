extends CanvasLayer
@onready var pause_menu = $"."


# Called when the node enters the scene tree for the first time.
func _process(delta):
	if Input.is_action_pressed("pause"):
		pause_menu.visible = true
		Engine.time_scale = 0


func _on_resume_pressed():
	Engine.time_scale = 1
	pause_menu.visible = false


func _on_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	Engine.time_scale = 1


func _on_quit_pressed():
	get_tree().quit()
