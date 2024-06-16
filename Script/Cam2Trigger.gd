extends Area3D

@onready var cam_1 = $"../../Cams/Cam1"
@onready var cam_2 = $"../../Cams/Cam2"

func _on_body_entered(body):
	if "Player" in body.name:
		cam_2.current = true
		cam_1.current = false
