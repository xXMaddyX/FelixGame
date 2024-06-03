extends Node2D

@onready var slime = $Slime
@onready var slime_2 = $Slime2
@onready var slime_3 = $Slime3
@onready var slime_4 = $Slime4

func setLightOn():
	slime.setLightsOn()
	slime_2.setLightsOn()
	slime_3.setLightsOn()
	slime_4.setLightsOn()
