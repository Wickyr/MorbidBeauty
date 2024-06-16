extends Area3D

@onready var player = $"../../Player"

func _on_body_entered(body):
	if "Player" in body.name:
		player.health = 0
