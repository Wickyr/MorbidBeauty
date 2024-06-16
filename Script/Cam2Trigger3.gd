extends Area3D
@onready var cam_2 = $"../../Cams/Cam2"
@onready var cam_3 = $"../../Cams/Cam3"
@onready var listener = $"../../Audio/AkListener3D"

func _on_body_entered(body):
	if "Player" in body.name:
		cam_2.current = true
		cam_3.current = false
		listener.position = cam_2.global_position
