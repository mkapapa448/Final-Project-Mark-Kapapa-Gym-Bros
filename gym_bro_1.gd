extends CharacterBody2D

const SPEED = 1100.0
const JUMP_VELOCITY = -1600.0

@onready var skeleton = $Bro 

@onready var push_zone_left = $push_zone_left
@onready var push_zone_right = $push_zone_right
@onready var push_zone_top = $push_zone_top
@onready var lift_zone_left = $lift_zone_left
@onready var lift_zone_right = $lift_zone_right

var facing = "right"


var push_left_last_body: RigidBody2D = null
var push_right_last_body: RigidBody2D = null

var last_state = null

var push_strength = (15000 + 75000 * (Game.energy1/100))
var lift_strength = (40000 + 130000 * (Game.energy1/100))

var is_pushing = false
var is_lifting = false

enum State {
	IDLE,
	RUN,
	PUSH,
	LIFT,
	FALL,
	JUMP
}

var state = State.IDLE

@onready var playback = $AnimationTree["parameters/playback"]

func _physics_process(delta: float) -> void:
	
	if Game.energy1 <= 0:
		queue_free()
	
	if (Input.is_action_pressed("pushright1") or Input.is_action_pressed("pushleft1")):
		is_pushing = true
	else:
		is_pushing = false

	if Input.is_action_pressed("lift1"):
		is_lifting = true
	else:
		is_lifting = false
	
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
	
	#if Input.is_action_pressed("pushright1") == false and Input.is_action_pressed("pushleft1") == false:
	if Input.is_action_pressed("pushright1") == false and Input.is_action_pressed("pushleft1") == false:
	#if true:
		var direction := Input.get_axis("left1", "right1")
		if direction:
			velocity.x = move_toward(velocity.x, direction * SPEED, 100)
			
			skeleton.scale.x = sign(direction)
			if direction < 0:
				facing = "left"
			elif direction > 0:
				facing = "right"
			else:
				pass
		else:
			velocity.x = move_toward(velocity.x, 0, 50)
	else:
		velocity.x = move_toward(velocity.x, 0, 50)
	
	if Input.is_action_pressed("pushright1") and facing == "right":
		var overlapping_bodies = push_zone_right.get_overlapping_bodies()
		for body in overlapping_bodies:
			if body is RigidBody2D:
				var current_body = body
				if current_body != push_right_last_body:
					Game.volume1 += body.mass
				
				if body.linear_velocity.y > 0:
					body.apply_central_impulse(Vector2(0,-lift_strength/10))
				#var push_dir = (body.global_position - global_position).normalized() 
				body.apply_central_impulse(Vector2(push_strength/20,0))
				#Game.energy1 -= body.mass/50
				
				push_right_last_body = current_body
				break
	#Reset last body for lifting volume hud thing"
	if Input.is_action_just_released("pushright1") and facing == "right":
		push_right_last_body = null

	if Input.is_action_just_pressed("pushright1") and facing == "right":
		#If body over player
		var overlapping_bodies = push_zone_top.get_overlapping_bodies()
		for body in overlapping_bodies:
			if body is RigidBody2D:
				playback.travel("throw")
				if body.linear_velocity.y > 0:
					body.apply_central_impulse(Vector2(0,-lift_strength/3))
				#var push_dir = (body.global_position - global_position).normalized() 
				body.apply_central_impulse(Vector2(push_strength/2.75,0))
				#Game.energy1 -= body.mass/50
				Game.volume1 += body.mass
				break
	
	if Input.is_action_pressed("pushleft1") and facing == "left":
		var overlapping_bodies = push_zone_left.get_overlapping_bodies()
		for body in overlapping_bodies:
			if body is RigidBody2D:
				var current_body = body
				if current_body != push_left_last_body:
					Game.volume1 += body.mass
				
				if body.linear_velocity.y > 0:
					body.apply_central_impulse(Vector2(0,-lift_strength/10))
				#var push_dir = (body.global_position - global_position).normalized() 
				body.apply_central_impulse(Vector2(-push_strength/20,0))
				#Game.energy1 -= body.mass/50
				push_left_last_body = current_body
				break
	
	#Reset last body for lifting volume hud thing
	if Input.is_action_just_released("pushleft1") and facing == "left":
		push_left_last_body = null
		
	if Input.is_action_just_pressed("pushleft1") and facing == "left":
		#If body over player
		var overlapping_bodies = push_zone_top.get_overlapping_bodies()
		for body in overlapping_bodies:
			if body is RigidBody2D:
				if body.linear_velocity.y > 0:
					body.apply_central_impulse(Vector2(0,-lift_strength/3))
				#var push_dir = (body.global_position - global_position).normalized() 
				body.apply_central_impulse(Vector2(-push_strength/2.75,0))
				#Game.energy1 -= body.mass/50
				Game.volume1 += body.mass
				break

	if Input.is_action_just_pressed("lift1"):
		if facing == "left":
			var overlapping_bodies = lift_zone_left.get_overlapping_bodies()
			for body in overlapping_bodies:
				if body is RigidBody2D:
					#var push_dir = (body.global_position - global_position).normalized() 
					# Apply an instantaneous central impulse
					body.apply_central_impulse(Vector2(0, -lift_strength/2.5))
					#Game.energy1 -= body.mass/50
					Game.volume1 += body.mass
				break
		elif facing == "right":
			var overlapping_bodies = lift_zone_right.get_overlapping_bodies()
			for body in overlapping_bodies:
				if body is RigidBody2D:
					#var push_dir = (body.global_position - global_position).normalized() 
					# Apply an instantaneous central impulse
					body.apply_central_impulse(Vector2(0, -lift_strength/2.5))
					#Game.energy1 -= body.mass/50
					Game.volume1 += body.mass
				break
		
	
	
	
	
	#if Input.is_action_just_pressed("pushright1"):
		#var overlapping_bodies = push_zone_right.get_overlapping_bodies()
		#var current_body: RigidBody2D = null
		#for body in overlapping_bodies:
			#if body is RigidBody2D:
				##Game.energy1 -= body.mass/100
				#if current_body != body:
					#Game.volume1 += body.mass
				#current_body = body
		#
		#overlapping_bodies = push_zone_top.get_overlapping_bodies()
		#for body in overlapping_bodies:
			#if body is RigidBody2D:
				##Game.energy1 -= body.mass/100
				#Game.volume1 += body.mass
	#
	#if Input.is_action_just_pressed("pushleft1"):
		#var overlapping_bodies = push_zone_left.get_overlapping_bodies()
		#for body in overlapping_bodies:
			#if body is RigidBody2D:
				##Game.energy1 -= body.mass/100
				#Game.volume1 += body.mass
#
		#overlapping_bodies = push_zone_top.get_overlapping_bodies()
		#for body in overlapping_bodies:
			#if body is RigidBody2D:
				##Game.energy1 -= body.mass/100
				#Game.volume1 += body.mass
#
	#if Input.is_action_pressed("lift1") and Input.is_action_pressed("left1"):
		#var overlapping_bodies = lift_zone_left.get_overlapping_bodies()
		#for body in overlapping_bodies:
			#if body is RigidBody2D:
				##var push_dir = (body.global_position - global_position).normalized() 
				## Apply an instantaneous central impulse
				#body.apply_central_force(Vector2(0, -lift_strength))
				##Game.energy1 -= body.mass/50
				#Game.volume1 += body.mass
	#
	#if Input.is_action_pressed("lift1") and Input.is_action_pressed("right1"):
		#var overlapping_bodies = lift_zone_right.get_overlapping_bodies()
		#for body in overlapping_bodies:
			#if body is RigidBody2D:
				##var push_dir = (body.global_position - global_position).normalized() 
				## Apply an instantaneous central impulse
				#body.apply_central_force(Vector2(0, -lift_strength))
				##Game.energy1 -= body.mass/50
				#Game.volume1 += body.mass
	#
	
	
	move_and_slide()
	update_state()
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	if last_state != state:
		match state:
			State.IDLE:
				playback.travel("idle")
			State.RUN:
				playback.travel("run")
			State.PUSH:
				playback.travel("push")
			State.LIFT:
				playback.travel("lift")
			State.JUMP:
				playback.travel("jump")
			State.FALL:
				playback.travel("fall")
		last_state = state
	#ddddddddvar overlapping_bodies = push_zone_top.get_overlapping_bodies()
	#for body in overlapping_bodies:
		#if body is RigidBody2D:
			#var push_dir = (body.global_position - global_position).normalized() 
			# Apply an instantaneous central impulse
			#body.apply_central_force(Vector2(0, -body.mass*250))
			#dGame.energy1 -= body.mass/100
	


#func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	#if anim_name == "push":
		#var direction = Input.get_axis("left1", "right1")
		#if direction != 0:
			#state = State.RUN
		#else:
			#state = State.IDLE

func update_state():
	if is_lifting:
		state = State.LIFT
	elif is_pushing:
		state = State.PUSH
	elif !is_on_floor() and velocity.y > 0:
		state = State.FALL
	elif !is_on_floor() and velocity.y < 0:
		state = State.JUMP
	elif abs(velocity.x) > 10:
		state = State.RUN
	else:
		state = State.IDLE


func _on_head_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		if body.linear_velocity.y >= 0:
			#body.apply_central_impulse((body.global_position - push_zone_top.global_position).normalized()*body.mass*1000 + Vector2(0, -body.mass*1000))
			body.apply_central_impulse(Vector2(0, -body.mass*2000))
			
