extends Area3D
@onready var cam_7 = $"../../Cams/Cam7"
@onready var cam_8 = $"../../Cams/Cam8"


func _on_body_entered(body):
	if "Player" in body.name:
		cam_8.current = true
		cam_7.current = false
