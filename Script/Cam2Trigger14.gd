extends Area3D
@onready var cam_7 = $"../../Cams/Cam7"
@onready var cam_9 = $"../../Cams/Cam9"
@onready var ak_listener_3d = $"../../Audio/AkListener3D"

func _on_body_entered(body):
	if "Player" in body.name:
		cam_7.current = true
		cam_9.current = false
		ak_listener_3d.position = cam_7.global_position
