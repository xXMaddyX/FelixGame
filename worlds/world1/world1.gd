extends Node2D

var actualMeetCount = 0
@onready var scene2 = preload("res://worlds/world2/world2.tscn")

func _ready():
	actualMeetCount = GameManager.meetCounter

func checkMeet():
	actualMeetCount = GameManager.meetCounter

func _process(_delta):
	checkMeet()
	if actualMeetCount >= 5:
		GameManager.meetCounter = 0
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://worlds/world2/world2.tscn")
