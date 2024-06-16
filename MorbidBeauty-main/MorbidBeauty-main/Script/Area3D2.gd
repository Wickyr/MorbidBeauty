extends Area3D
@onready var area_3d_2 = $"."
@onready var rat_3 = $"../Rat_3"
@onready var monster_smash = $"../Monster_smash"

func _on_body_entered(body):
	if body.is_in_group("Player"):
		monster_smash.queue_free()
		rat_3.queue_free()


func _on_body_exited(body):
	if body.is_in_group("Player"):
		area_3d_2.queue_free()
