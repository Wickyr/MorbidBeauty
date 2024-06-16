extends CSGBox3D

var toggle = false
var interactable = true

func interact():
	if interactable == true:
		interactable = false
		toggle = !toggle 
		if toggle == false:
			pass
		if toggle == true:
			get_tree().change_scene_to_file("res://Scenes/main_2.tscn")
		interactable = true




