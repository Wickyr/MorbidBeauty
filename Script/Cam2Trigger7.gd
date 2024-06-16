extends Area3D
@onready var cam_4 = $"../../Cams/Cam4"
@onready var cam_5 = $"../../Cams/Cam5"


func _on_body_entered(body):
	if "Player" in body.name:
		cam_5.current = true
		cam_4.current = false
