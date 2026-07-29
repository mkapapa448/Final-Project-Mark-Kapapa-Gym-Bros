extends Marker2D
@export var player1 = CharacterBody2D
@export var player2 = CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = (player2.position + player1.position) / 2
