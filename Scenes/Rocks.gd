extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	Wwise.register_game_obj(self, self.name)
	Wwise.set_3d_position(self, transform)
	Wwise.post_event_id(AK.EVENTS.ROCKSCRUMBLING, self)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
