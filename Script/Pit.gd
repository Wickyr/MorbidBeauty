extends Area3D

@onready var player = $"../../Player"

func _on_body_entered(body):
	if "Player" in body.name:
		player.health = 0
		Wwise.register_game_obj(self, self.name)
		Wwise.set_3d_position(self, transform)
		Wwise.post_event_id(AK.EVENTS.DEATH, self)
