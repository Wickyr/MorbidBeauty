extends CharacterBody3D


@export var SPEED = 5.0
@export var walkingspeed = 5.0
@export var crouchspeed = 3.0
@export var health = 30
@export var fullhealth = 30
@onready var stand = $Stand
var crouched : bool
var rotate = .05
var direction = Vector3.ZERO
@onready var gameover = $"../Gameover"
var attacking = false
@onready var attacketime = $Attacketime
@onready var anim = $Fleshman_4/AnimationPlayer
@onready var dead = false
@export var Spawn = preload("res://Scenes/rat_splatter.tscn")
@onready var foot = $Foot
@onready var heal_timer = $HealTimer
@export var noisy : bool


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _process(delta):
	if health < fullhealth && dead == false:
		heal_timer.start()
		print("hurt")
	if noisy == true:
		print("noisy")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var input_dir = Input.get_vector("PlaceHolder1", "PlaceHolder2", "w", "s")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	
	if health <= 0:
		print("Dead")
		dead = true
		velocity.z = 0
		velocity.x = 0
		anim.play("Death")
		gameover.visible = true
	else:
		if Input.is_action_pressed("w") and Input.is_action_just_pressed("s"):
			velocity.z = 0
			velocity.x = 0
		elif Input.is_action_pressed("w") and attacking == false:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			anim.play("Walking")
			anim.speed_scale = 1
		elif Input.is_action_pressed("s") and attacking == false:
			velocity.x = -direction.x * -SPEED/2
			velocity.z = -direction.z * -SPEED/2
			anim.play("Walking")
			anim.speed_scale = -1
		else: 
			velocity.z = 0
			velocity.x = 0
			if attacking == false:
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
	
	if Input.is_action_just_pressed("attack") && dead != true:
		attacking = true
		rotate_y(0)
		SPEED = 0
		attacketime.start()
		print("attacked")
		anim.play("Stomp")
		anim.speed_scale = 2

func _on_attack_area_body_entered(body):
	if attacking == true:
		if "Rat" in body.name:
			body.queue_free()
			var Splatter = Spawn.instantiate()
			add_sibling(Splatter)
			Splatter.position = foot.global_position

func _on_timer_timeout():
	attacking = false
	SPEED = 3
	print("attack stop")
	anim.play("Action")

func _on_heal_timer_timeout():
	health = fullhealth
	print("Healed")
