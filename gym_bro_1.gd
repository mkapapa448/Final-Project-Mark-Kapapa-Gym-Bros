extends CharacterBody2D

const SPEED = 1100.0
const JUMP_VELOCITY = -1600.0

@onready var skeleton = $Bro 

@onready var push_zone_left = $push_zone_left
@onready var push_zone_right = $push_zone_right
@onready var push_zone_top = $push_zone_top
@onready var lift_zone_left = $lift_zone_left
@onready var lift_zone_right = $lift_zone_right

var push_strength = 30000
var lift_strength = 45000
var throw_strength = 20000

enum State {
	IDLE,
	RUN,
	PUSH,
	LIFT,
	THROW
}

var state = State.IDLE

@onready var playback = $AnimationTree["parameters/playback"]

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("up1") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_released("up1") and velocity.y < 0:
		velocity.y /= 2.5
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if Input.is_action_pressed("pushright1") == false and Input.is_action_pressed("pushleft1") == false:
		var direction := Input.get_axis("left1", "right1")
		if direction:
			velocity.x = move_toward(velocity.x, direction * SPEED, 100)
			skeleton.scale.x = sign(direction)
			$AnimationPlayer.speed_scale = 1.5
		else:
			velocity.x = move_toward(velocity.x, 0, 50)
			$AnimationPlayer.speed_scale = 1.0
			
		if direction != 0:
			state = State.RUN
		elif Input.is_action_pressed("lift1") == false:
			state = State.IDLE
		else:
			state = State.LIFT
	else:
		velocity.x = move_toward(velocity.x, 0, 50)
		$AnimationPlayer.speed_scale = 3.0
		state = State.PUSH
	move_and_slide()
	
	
	match state:
		State.IDLE:
			playback.travel("idle")
		State.RUN:
			playback.travel("run")
		State.PUSH:
			playback.travel("push")
		State.LIFT:
			playback.travel("lift")
	
	if Input.is_action_just_pressed("pushright1"):
		var overlapping_bodies = push_zone_right.get_overlapping_bodies()
		for body in overlapping_bodies:
			if body is RigidBody2D:
				#var push_dir = (body.global_position - global_position).normalized() 
				# Apply an instantaneous central impulse
				body.apply_central_impulse(Vector2(push_strength,0))
	
	if Input.is_action_just_pressed("pushleft1"):
		var overlapping_bodies = push_zone_left.get_overlapping_bodies()
		for body in overlapping_bodies:
			if body is RigidBody2D:
				#var push_dir = (body.global_position - global_position).normalized() 
				# Apply an instantaneous central impulse
				body.apply_central_impulse(Vector2(-push_strength,0))

	if Input.is_action_just_pressed("lift1"):
		var overlapping_bodies = lift_zone_left.get_overlapping_bodies()
		for body in overlapping_bodies:
			if body is RigidBody2D:
				#var push_dir = (body.global_position - global_position).normalized() 
				# Apply an instantaneous central impulse
				body.apply_central_impulse(Vector2(0, -lift_strength))
		overlapping_bodies = lift_zone_right.get_overlapping_bodies()
		for body in overlapping_bodies:
			if body is RigidBody2D:
				#var push_dir = (body.global_position - global_position).normalized() 
				# Apply an instantaneous central impulse
				body.apply_central_impulse(Vector2(0, -lift_strength))


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "push":
		var direction = Input.get_axis("left1", "right1")
		if direction != 0:
			state = State.RUN
		else:
			state = State.IDLE
