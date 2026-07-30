extends CanvasLayer

@onready var energy_label_1 = $Control/HBoxContainer/Player1/Energy
@onready var volume_label_1 = $Control/HBoxContainer/Player1/Volume
@onready var energy_label_2 = $Control/HBoxContainer/Player2/Energy
@onready var volume_label_2 = $Control/HBoxContainer/Player2/Volume

func _ready():
	energy_label_1.text = "Energy: " + str(Game.energy1)
	energy_label_2.text = "Energy: " + str(Game.energy2)
	volume_label_1.text = "Lifting Volume: " + str(Game.volume1) + " kgs"
	volume_label_2.text = "Lifting Volume: " + str(Game.volume2) + " kgs"

func _process(delta):
	energy_label_1.text = "Energy: " + str(round(Game.energy1))
	energy_label_2.text = "Energy: " + str(round(Game.energy2))
	volume_label_1.text = "Lifting Volume: " + str(Game.volume1) + " kgs"
	volume_label_2.text = "Lifting Volume: " + str(Game.volume2) + " kgs"
