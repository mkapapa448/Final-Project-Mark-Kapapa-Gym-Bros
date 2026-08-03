extends Area2D

@onready var nav_agent = $NavigationAgent2D
@export var newbullet: PackedScene
@export var target = CharacterBody2D

@export var bullet_speed = 6
@export var bullet_damage = 12
var can_shoot = true
@export var health = 3

@export var timer_length = 1.5

@onready var shottimer = $shot_timer

@export var speed = 10
@export var stopped = false

var impact_vector: Vector2 = Vector2.ZERO

signal die

var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	#$shot_timer.wait_time = timer_length
	pass
func _process(delta: float) -> void:
	
	if health <= 0:
		die.emit()
		Game.defeated_boss = true
		queue_free()
		
	if not target:
		return
	
	
	nav_agent.target_position = target.global_position
	
	if nav_agent.is_navigation_finished():
		return
	
	var agent_position = global_position
	var next_position = nav_agent.get_next_path_position()
	
	if Game.boss_unlocked:
		velocity = agent_position.direction_to(next_position) * speed
		shottimer.wait_time = 3
		#$Sprite2D.rotation = (target.global_position - global_position).angle()
		#$muzzle.rotation = (target.global_position - global_position).angle()
		
	if can_shoot:
		var new_bullet = newbullet.instantiate()
		#new_bullet.rotation = (target.global_position - global_position).angle()
		#new_bullet.speed = bullet_speed
	#new_bullet.damage = bullet_damage
		new_bullet.global_position = $Node2D/Marker2D.global_position
		new_bullet.target = target
		
		get_tree().root.add_child(new_bullet)
		can_shoot = false
		shottimer.start()
		
	if impact_vector != Vector2(0, 0):
		velocity += impact_vector
		impact_vector *= 0.9
		
	position += velocity

func _on_shot_timer_timeout() -> void:
	can_shoot = true


func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		impact_vector += Vector2.ZERO + body.linear_velocity/25
		health -= 1
		
	elif body is CharacterBody2D and body.name == "player1":
		Game.energy1 -= 40
		body.velocity += velocity * 150
		impact_vector += Vector2.ZERO + Vector2(0, -150)
