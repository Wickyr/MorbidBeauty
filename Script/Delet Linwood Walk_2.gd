extends Area3D

@onready var lin_wood_2 = $"../../LinWood_2"
@onready var delet_linwood_walk_2 = $"."

func _on_body_entered(body):
	if body.is_in_group("Player"):
		lin_wood_2.queue_free()

func _on_body_exited(body):
	if body.is_in_group("Player"):
		delet_linwood_walk_2.queue_free()
