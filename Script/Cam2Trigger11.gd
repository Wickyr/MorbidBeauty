extends Area3D
@onready var cam_7 = $"../../Cams/Cam7"
@onready var cam_8 = $"../../Cams/Cam8"
@onready var ak_listener_3d = $"../../Audio/AkListener3D"

func _on_body_entered(body):
	if "Player" in body.name:
		cam_8.current = true
		cam_7.current = false
		ak_listener_3d.position = cam_8.global_position
