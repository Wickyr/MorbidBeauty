extends CSGBox3D

var toggle = false
var interactable = true
@onready var animation_player = $"../../AnimationPlayer"
@onready var press_e = $"../../Sprite3D"

func interact():
	if interactable == true:
		interactable = false
		toggle = !toggle 
		if toggle == false:
			animation_player.play("Door Close")
		if toggle == true:
			animation_player.play("Door Open")
		await get_tree().create_timer(1,0, false).timeout
		interactable = true



func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		press_e.visible = true

func _on_area_3d_body_exited(body):
	if body.is_in_group("Player"):
		press_e.visible = false


