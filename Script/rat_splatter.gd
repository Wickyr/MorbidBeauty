extends Node3D
class_name Splatter
@onready var gpu_particles_3d = $GPUParticles3D


# Called when the node enters the scene tree for the first time.
func _ready():
	gpu_particles_3d.emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
