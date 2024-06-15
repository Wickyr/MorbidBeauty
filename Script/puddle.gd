extends Node3D

var player
@onready var noisy : bool 

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]


func _on_area_3d_body_entered(body):
	if "Player" in body.name:
		noisy = true
		print("Noisy")
	if "Rat" in body.name:
		noisy = true


func _on_area_3d_body_exited(body):
	if "Player" in body.name:
		noisy = false
		print("Not Noisy")
	if "Rat" in body.name:
		noisy = false
