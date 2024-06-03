extends Node2D

@onready var fire_monster = $FireMonster
@onready var fire_monster_2 = $FireMonster2

func setLightOn():
	fire_monster.setLightsOn()
	fire_monster_2.setLightsOn()
