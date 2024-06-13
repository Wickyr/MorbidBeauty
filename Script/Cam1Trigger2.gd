extends Area3D

@onready var cam_3 = $"../../Cams/Cam3"
@onready var cam_1 = $"../../Cams/Cam1"


func _on_body_entered(body):
	if "Player" in body.name:
		cam_1.current = true
		cam_3.current = false
