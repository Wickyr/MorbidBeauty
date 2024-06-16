extends Area3D
@onready var cam_4 = $"../../Cams/Cam4"
@onready var cam_3 = $"../../Cams/Cam3"


func _on_body_entered(body):
	if "Player" in body.name:
		cam_4.current = false
		cam_3.current = true
