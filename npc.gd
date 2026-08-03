extends StaticBody2D

@onready var dialogue_box = $Sprite2D2
@onready var dialogue_text = $Sprite2D2/Label

var dialogue = [["So bro, I have something to tell you...", "Can you go take care of the ghost knight bro?\nIt's my rest day.", "They say\nnobody has ever reached\nthe top of the tower\nand defeated him.", "Good luck and thanks!"],["What are you waiting around here for?","Enter the castle!"],["You did it!!"]]
var dialogue_active = false
var dialogue_message = 0
var dialogue_stage = 0

var in_zone = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if in_zone and Input.is_action_just_pressed('interact'):
		if Game.win == false:
			$Label.hide()
			$Sprite2D3.hide()
		if dialogue_active != true:
			dialogue_active = true
			if dialogue_stage == 1 and Game.defeated_boss == true:
				dialogue_stage += 1
				Game.win = true
			dialogue_box.show()
			dialogue_text.show()
			update_dialogue()
		elif dialogue_message < dialogue[dialogue_stage].size() - 1:
			dialogue_message += 1
			update_dialogue()
		elif Game.win != true:
			dialogue_active = false
			dialogue_message = 0
			if dialogue_stage == 0:
				dialogue_stage += 1
				get_parent().get_node("door1").queue_free()
			
			
	if dialogue_active == false:
		dialogue_box.hide()
		dialogue_text.hide()


func update_dialogue():
	dialogue_text.text = dialogue[dialogue_stage][dialogue_message]

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		in_zone = true
		$Label.show()
		$Sprite2D3.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		in_zone = false
		dialogue_active = false
		dialogue_message = 0
		$Label.hide()
		$Sprite2D3.hide()
