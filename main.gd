extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Game.energy1 <= 0:
		await get_tree().create_timer(3).timeout
		get_tree().change_scene_to_file("res://lose.tscn")
	if Game.defeated_boss == true:
		await get_tree().create_timer(3).timeout
		get_tree().change_scene_to_file("res://win.tscn")



func _on_boss_fight_area_body_entered(body: Node2D) -> void:
	if body.name == "player1":
		Game.boss_unlocked = true
