extends Area3D
@onready var cam_10 = $"../../Cams/Cam10"
@onready var cam_8 = $"../../Cams/Cam8"
@onready var ak_listener_3d = $"../../Audio/AkListener3D"

func _on_body_entered(body):
	if "Player" in body.name:
		cam_10.current = true
		cam_8.current = false
		ak_listener_3d.position = cam_10.global_position
