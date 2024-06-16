extends CharacterBody3D

@export var SPEED = 5.0
@export var walkingspeed = 5.0
@export var crouchspeed = 3.0
@export var health = 30
@onready var stand = $Stand
var crouched : bool
var noisy : bool
var rotate = .05
var direction = Vector3.ZERO
@onready var gameover = $"../Gameover"
var attacking = false
@onready var attacketime = $Attacketime
@onready var anim = $Fleshman_4/AnimationPlayer
var dead = false
@export var Spawn = preload("res://Scenes/rat_splatter.tscn")
@onready var foot = $Foot
@onready var walking = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var deathSoundPlayed = false
# Footstep sound cooldown variables
var footstepCooldown = 0.6  # Adjust as needed, in seconds
var footstepTimer = 0.0
@onready var collision_shape_3d = $Fleshman_4/AttackArea/CollisionShape3D


func _ready():
	Wwise.register_game_obj(self, self.name)
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir = Input.get_vector("PlaceHolder1", "PlaceHolder2", "w", "s")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if health <= 0 and not dead:
		print("Dead")
		dead = true
		velocity.x = 0
		velocity.z = 0
		SPEED = 0  # Stop all movement
		walking = false
		anim.play("Death")  # Play death animation
		gameover.visible = true
		if not deathSoundPlayed:
			Wwise.set_3d_position(self, transform)
			Wwise.post_event_id(AK.EVENTS.DEATH, self)
			deathSoundPlayed = true
	else:
		if Input.is_action_pressed("w") and Input.is_action_just_pressed("s"):
			velocity.z = 0
			velocity.x = 0
		elif Input.is_action_pressed("w") and not attacking and walking == true:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			anim.play("Walking")
			if footstepTimer >= footstepCooldown:
				Wwise.set_3d_position(self, transform)
				Wwise.post_event_id(AK.EVENTS.WALKING, self)
				footstepTimer = 0.0  # Reset timer after playing sound
			else:
				footstepTimer += delta
			anim.speed_scale = 1
		elif Input.is_action_pressed("s") and not attacking and walking == true:
			velocity.x = -direction.x * -SPEED/2
			velocity.z = -direction.z * -SPEED/2
			anim.play("Walking")
			if footstepTimer >= footstepCooldown:
				Wwise.set_3d_position(self, transform)
				Wwise.post_event_id(AK.EVENTS.WALKING, self)
				footstepTimer = 0.0  # Reset timer after playing sound
			else:
				footstepTimer += delta
			anim.speed_scale = -1
		else: 
			velocity.z = 0
			velocity.x = 0
			if not attacking and not dead:  # Ensure to play action animation if not dead
				anim.play("Action")
	
	if health <= 0:
		rotate_y(0)
	else:
		if Input.is_action_pressed("a") and Input.is_action_just_pressed("d"):
			rotate_y(0)
			velocity.z = 0
			velocity.x = 0
		elif Input.is_action_pressed("a"):
			rotate_y(rotate)
		elif Input.is_action_pressed("d"):
			rotate_y(-rotate)
		else: 
			rotate_y(0)
	move_and_slide()

	if Input.is_action_just_pressed("attack") && not dead:
		attacking = true
		rotate_y(0)
		SPEED = 0
		attacketime.start()
		print("attacked")
		anim.play("Stomp")
		anim.speed_scale = 2
		collision_shape_3d.disabled = false
		Wwise.set_3d_position(self, transform)
		Wwise.post_event_id(AK.EVENTS.STOMP, self)

func _on_attack_area_body_entered(body):
	if attacking == true:
		if body.is_in_group("Rat"):
			body.queue_free()
			var Splatter = Spawn.instantiate()
			add_sibling(Splatter)
			Splatter.position = foot.global_position
			Wwise.set_3d_position(self, transform)
			Wwise.post_event_id(AK.EVENTS.RATDEATH, self)
			
func _on_timer_timeout():
	attacking = false
	SPEED = 3
	collision_shape_3d.disabled = true
	print("attack stop")
	anim.play("Action")
	
func _on_sound_timer_timeout():
		if not dead:
			Wwise.post_event_id(AK.EVENTS.WALKING, self)
