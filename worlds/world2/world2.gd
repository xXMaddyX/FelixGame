extends Node2D

var actualMeetCount = 0
const WORLD_3 = preload("res://worlds/world3/world3.tscn")

func _ready():
	actualMeetCount = GameManager.meetCounter

func checkMeet():
	actualMeetCount = GameManager.meetCounter
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	checkMeet()
	if actualMeetCount >= 5:
		GameManager.meetCounter = 0
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://worlds/world3/world3.tscn")
