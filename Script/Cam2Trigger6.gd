extends Area3D
@onready var cam_4 = $"../../Cams/Cam4"
@onready var cam_5 = $"../../Cams/Cam5"
@onready var listener = $"../../Audio/AkListener3D"

func _on_body_entered(body):
	if "Player" in body.name:
		cam_5.current = false
		cam_4.current = true
		listener.position = cam_4.global_position
