extends Area3D

@onready var cam_1 = $"../../Cams/Cam1"
@onready var cam_2 = $"../../Cams/Cam2"
@onready var listener = $"../../Audio/AkListener3D"

func _on_body_entered(body):
	if "Player" in body.name:
		cam_1.current = true
		cam_2.current = false
		listener.position = cam_1.global_position
