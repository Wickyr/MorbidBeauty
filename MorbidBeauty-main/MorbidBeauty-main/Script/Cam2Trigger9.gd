extends Area3D

@onready var cam_5 = $"../../Cams/Cam5"
@onready var cam_6 = $"../../Cams/Cam6"


func _on_body_entered(body):
	if "Player" in body.name:
		cam_6.current = true
		cam_5.current = false
