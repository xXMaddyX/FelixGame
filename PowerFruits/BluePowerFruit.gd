extends Node2D

var Power = "Water"

func _on_area_2d_body_entered(body):
	GameManager.changeDinoPowerState(Power)
	GameManager.updateDinoPowerState()
	queue_free()

