extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	Wwise.register_game_obj(self, self.name)
	Wwise.post_event_id(AK.EVENTS.FIRSTSIGHT, self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
