extends Area3D
@onready var cam_11 = $"../../Cams/Cam11"
@onready var cam_10 = $"../../Cams/Cam10"


func _on_body_entered(body):
	if "Player" in body.name:
		cam_10.current = true
		cam_11.current = false
