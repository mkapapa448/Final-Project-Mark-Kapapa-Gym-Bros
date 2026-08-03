extends Area2D

@onready var nav_agent = $NavigationAgent2D
@export var newbullet: PackedScene
@export var target: CharacterBody2D

@export var bullet_speed = 6
@export var bullet_damage = 12
var can_shoot = true
@export var health = 50

@export var timer_length = 1.5

@onready var shottimer = $shot_timer

@export var initial_speed = 8
var speed
@export var stopped = false

signal die
var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	#$shot_timer.wait_time = timer_length
	pass
func _physics_process(delta: float) -> void:
	if stopped == false:
		if health <= 0:
			die.emit()
			queue_free()
		
		if not target:
			return
		
		speed = initial_speed + (1/((target.global_position - global_position).length()))
		nav_agent.target_position = target.global_position
		
		if nav_agent.is_navigation_finished():
			return
		
		var agent_position = global_position
		var next_position = nav_agent.get_next_path_position()
		velocity = agent_position.direction_to(next_position) * speed
		
		#$Sprite2D.rotation = (target.global_position - global_position).angle()
		#$muzzle.rotation = (target.global_position - global_position).angle()

		position += velocity

func _on_shot_timer_timeout() -> void:
	can_shoot = true


func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		queue_free()
	elif body is CharacterBody2D and body.name == "player1":
		Game.energy1 -= 5
		queue_free()
