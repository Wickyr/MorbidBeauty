extends CharacterBody3D
enum States{
	patrol,
	chasing,
	hunting,
	waiting,
	attack
}

var currentState : States
var navAgent : NavigationAgent3D
@export var waypoints : Array[Node]
var waypointIndex : int
@export var patrolspeed = 4
@export var chasespeed = 5
@export var attack = false
@export var damage = 10
@onready var patrol_timer = $PatrolTimer
var player

var PlayerEarShotFar : bool
var PlayerEarShotClose : bool
var PlayerSightFar : bool
var PlayerSightClose : bool
var puddle 
# Footstep sound cooldown variables
var footstepCooldown = 0.8  # Adjust as needed, in seconds
var runFootstepCooldown = 0.4
var footstepTimer = 0.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var anim = $LinWood_1/AnimationPlayer
@onready var fleshman_4 = $Fleshman_4
@onready var stop = $Stop
@onready var grabcam = $Grabcam

# Called when the node enters the scene tree for the first time.
func _ready():
	navAgent = $NavigationAgent3D
	currentState = States.patrol
	navAgent.set_target_position(waypoints[0].global_position)
	player = get_tree().get_nodes_in_group("Player")[0]
	puddle = get_tree().get_nodes_in_group("Puddle")
	Wwise.register_game_obj(self, self.name)


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match currentState:
		States.patrol:
			if(navAgent.is_navigation_finished()):
				currentState = States.waiting
				patrol_timer.start()
				anim.play("Idle")
				return
			MoveTowardPoint(delta, patrolspeed)
			anim.play("Walk")
			if footstepTimer >= footstepCooldown:
				Wwise.set_3d_position(self, transform)
				Wwise.post_event_id(AK.EVENTS.WALK, self)
				footstepTimer = 0.0  # Reset timer after playing sound
			else:
				footstepTimer += delta
			pass
		States.chasing:
			if(navAgent.is_navigation_finished()):
				patrol_timer.start()
				currentState = States.waiting
				anim.play("Idle")
			navAgent.set_target_position(player.global_position)
			MoveTowardPoint(delta, chasespeed)
			anim.play("Run")
			if footstepTimer >= runFootstepCooldown:
				Wwise.set_3d_position(self, transform)
				Wwise.post_event_id(AK.EVENTS.WALK, self)
				footstepTimer = 0.0  # Reset timer after playing sound
			else:
				footstepTimer += delta
			pass
		States.hunting:
			if(navAgent.is_navigation_finished()):
				patrol_timer.start()
				currentState = States.waiting
				anim.play("Idle")
			MoveTowardPoint(delta, patrolspeed)
			anim.play("Walk")
			if footstepTimer >= footstepCooldown:
				Wwise.set_3d_position(self, transform)
				Wwise.post_event_id(AK.EVENTS.WALK, self)
				footstepTimer = 0.0  # Reset timer after playing sound
			else:
				footstepTimer += delta
			pass
		States.attack:
			anim.play("Grab")
			fleshman_4.visible = true
			grabcam.current = true
		States.waiting:
			pass

func MoveTowardPoint(delta, speed):
	var targetPos = navAgent.get_next_path_position()
	var direction = global_position.direction_to(targetPos)
	faceDirection(targetPos)
	velocity = direction * speed
	move_and_slide()
	if(PlayerEarShotFar):
		CheckForPlayer()

func CheckForPlayer():
	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(PhysicsRayQueryParameters3D.create($Head.global_position, get_tree().get_nodes_in_group("Player")[0].global_position, 1, [self]))
	if result.size() > 0:
		if(result["collider"].is_in_group("Player")):
			if(PlayerEarShotClose):
				if(result["collider"].crouched == false):
					currentState = States.chasing
			if(PlayerEarShotFar):
				currentState = States.hunting
				print("heard")
				navAgent.set_target_position(player.global_position)

func faceDirection(direction : Vector3):
	look_at(Vector3(direction.x, global_position.y, direction.z), Vector3.UP)

func _on_patrol_timer_timeout():
	currentState = States.patrol
	waypointIndex += 1
	if waypointIndex > waypoints.size() - 1:
		waypointIndex = 0
	navAgent.set_target_position(waypoints[waypointIndex].global_position)


func _on_hearing_far_body_entered(body):
	if body.is_in_group("Player"):
		PlayerEarShotFar = true


func _on_hearing_far_body_exited(body):
	if body.is_in_group("Player"):
		PlayerEarShotFar = false


func _on_hearingclose_body_entered(body):
	if body.is_in_group("Player"):
		PlayerEarShotClose = true


func _on_hearingclose_body_exited(body):
	if body.is_in_group("Player"):
		PlayerEarShotClose = false



func _on_attack_area_body_entered(body):
	if body.is_in_group("Player"):
		attack = true
		player.health = 0
		anim.play("Grab")
		chasespeed = 0
		print("enemy attack")
		player.visible = false
		currentState = States.attack



func _on_attack_area_body_exited(body):
	if body.is_in_group("Player"):
		attack = false
		currentState = States.chasing


func _on_long_hearing_body_entered(body):
	if body.is_in_group("Player"):
		if player.noisy == true:
			navAgent.set_target_position(player.position)
		if(navAgent.is_navigation_finished()):
			patrol_timer.start()
			currentState = States.waiting


func _on_long_hearing_body_exited(body):
	pass # Replace with function body.



