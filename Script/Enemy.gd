extends CharacterBody3D
enum States{
	patrol,
	chasing,
	hunting,
	waiting,
	attacking,
	dead
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

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var dead : bool
@onready var attack_timer = $AttackTImer
@onready var anim = $Rat_2/AnimationPlayer
@onready var timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	dead = false
	if dead == true:
		currentState = States.dead
	navAgent = $NavigationAgent3D
	currentState = States.patrol
	navAgent.set_target_position(waypoints[0].global_position)
	player = get_tree().get_nodes_in_group("Player")[0]
	Wwise.register_game_obj(self, self.name)
	Wwise.register_listener(self)
	Wwise.load_bank_id(AK.BANKS.INIT)
	Wwise.load_bank_id(AK.BANKS.MAIN)

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
			anim.play("Run")
			anim.speed_scale = 1
			pass
		States.chasing:
			if(navAgent.is_navigation_finished()):
				patrol_timer.start()
				currentState = States.waiting
				anim.play("Idle")
			navAgent.set_target_position(player.global_position)
			MoveTowardPoint(delta, chasespeed)
			anim.play("Run")
			anim.speed_scale = 2
			pass
		States.hunting:
			if(navAgent.is_navigation_finished()):
				patrol_timer.start()
				currentState = States.waiting
				anim.play("Idle")
			MoveTowardPoint(delta, patrolspeed)
			anim.play("Run")
			anim.speed_scale = 1
			pass
		States.waiting:
			pass
		States.attacking:
			pass
		States.dead:
			PlayerEarShotFar = false
			PlayerEarShotClose = false
			PlayerSightFar = false
			PlayerSightClose = false
			print("Is Dead")

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
					currentState = States.chasing
			if(PlayerEarShotFar):
				if(result["collider"].crouched == false):
					currentState = States.hunting
					print("heard")
					navAgent.set_target_position(player.global_position)
			if(PlayerSightClose):
				currentState = States.chasing
			if(PlayerSightFar):
				if(result["collider"].crouched == false):
					currentState = States.hunting
					print("hunt")
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


func _on_sightfar_body_entered(body):
	if body.is_in_group("Player"):
		PlayerSightFar = true



func _on_sightfar_body_exited(body):
	if body.is_in_group("Player"):
		PlayerSightFar = false


func _on_sight_close_body_entered(body):
	if body.is_in_group("Player"):
		PlayerSightClose = true



func _on_sight_close_body_exited(body):
	if body.is_in_group("Player"):
		PlayerSightClose = false


func _on_attack_area_body_entered(body):
	if body.is_in_group("Player"):
		attack = true
		attack_timer.start()
		chasespeed = 0
		print("enemy attack")
		anim.play("Idle")
		currentState = States.attacking
		return


func _on_attack_area_body_exited(body):
	if body.is_in_group("Player"):
		attack = false
		currentState = States.chasing


func _on_attack_t_imer_timeout():
	timer.start()
	anim.play("Attack")
	anim.speed_scale = 1
			
func _on_timer_timeout():
	if attack == true:
		player.health = player.health - 3
		Wwise.post_event_id(AK.EVENTS.DAMAGE, self)
		chasespeed = 5
