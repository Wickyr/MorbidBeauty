extends Node3D
class_name Splatter
@onready var gpu_particles_3d = $GPUParticles3D


# Called when the node enters the scene tree for the first time.
func _ready():
	gpu_particles_3d.emitting = true
	Wwise.register_game_obj(self, self.name)
	Wwise.register_listener(self)
	Wwise.load_bank_id(AK.BANKS.INIT)
	Wwise.load_bank_id(AK.BANKS.MAIN)
	Wwise.post_event_id(AK.EVENTS.RATDEATH, self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
