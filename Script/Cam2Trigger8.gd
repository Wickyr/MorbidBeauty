extends Area3D

@onready var cam_5 = $"../../Cams/Cam5"
@onready var cam_6 = $"../../Cams/Cam6"
@onready var listener = $"../../Audio/AkListener3D"

func _on_body_entered(body):
	if "Player" in body.name:
		cam_5.current = true
		cam_6.current = false
		listener.position = cam_5.global_position
