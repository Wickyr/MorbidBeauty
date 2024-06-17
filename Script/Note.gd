extends Node3D
var toggle = false
var interactable = true
@onready var pree_e = $"../../Label3D"
@onready var Note = $"../../Notes/Sprite2D"


func interact():
	if interactable == true:
		interactable = false
		toggle = !toggle 
		if toggle == false:
			Note.visible = false
		if toggle == true:
			Note.visible = true
		await get_tree().create_timer(1,0, false).timeout
		interactable = true


func _on_area_3d_body_exited(body):
	if body.is_in_group("Player"):
		Note.visible = false
		pree_e.visible = false


func _on_area_3d_body_entered(body):
	pree_e.visible = true
