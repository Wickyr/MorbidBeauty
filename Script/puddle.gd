extends Node3D

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]


func _on_area_3d_body_entered(body):
	if "Player" in body.name:
		player.noisy = true
		Wwise.register_game_obj(self, self.name)
		Wwise.set_3d_position(self, transform)
		Wwise.post_event_id(AK.EVENTS.PUDDLE, self)
		print("Noisy")


func _on_area_3d_body_exited(body):
	if "Player" in body.name:
		player.noisy = false
		print("Not Noisy")

