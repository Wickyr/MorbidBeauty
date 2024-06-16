extends Area3D
@onready var area_3d = $"."
@onready var animation_player = $"../Rat_3/AnimationPlayer"
@onready var animation_player2 = $"../Monster_smash/AnimationPlayer"
@onready var animation_player_2 = $"../Rat_3/AnimationPlayer2"


func _on_body_entered(body):
	if body.is_in_group("Player"):
		animation_player2.play("Action")
		animation_player.play("Run")
		animation_player_2.play("Move")


func _on_body_exited(body):
	if body.is_in_group("Player"):
		area_3d.queue_free()
