extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
	Game.energy1 = 100
	Game.volume1 = 0
	Game.energy2 = 100
	Game.volume2 = 0
	Game.checkpoint = 0
	Game.boss_unlocked = false
	Game.defeated_boss = false
