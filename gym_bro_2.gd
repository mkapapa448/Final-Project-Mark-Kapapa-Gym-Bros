extends CharacterBody2D

const SPEED = 1400.0
const JUMP_VELOCITY = -1300.0

@onready var skeleton = $Bro 

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("up2") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_released("up2") and velocity.y < 0:
		velocity.y /= 2.5
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left2", "right2")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, 100)
		skeleton.scale.x = sign(direction)
		$AnimationPlayer.speed_scale = 1.5
	else:
		velocity.x = move_toward(velocity.x, 0, 50)
		$AnimationPlayer.speed_scale = 1.0

	if direction != 0:
		$AnimationTree["parameters/playback"].travel("run")
	else:
		$AnimationTree["parameters/playback"].travel("idle")

	move_and_slide()
