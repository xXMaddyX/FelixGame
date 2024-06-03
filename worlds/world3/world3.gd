extends Node2D

var actualMeetCounter = 0
var player
@onready var fire_mobs = $FireMobs
@onready var slimes = $Slimes

# Called when the node enters the scene tree for the first time.
func _ready():
	actualMeetCounter = GameManager.meetCounter
	player = $Player
	player.setLightsOn()
	fire_mobs.setLightOn()
	slimes.setLightOn()

func checkMeet():
	actualMeetCounter = GameManager.meetCounter

func _process(_delta):
	checkMeet()
	if actualMeetCounter >= 10:
		print("LvL Done")
