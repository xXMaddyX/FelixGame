extends Node2D

var isCollcted = false
# Called when the node enters the scene tree for the first time.

func collectHandler():
	isCollcted = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if delta:
		if isCollcted:
			queue_free()


func _on_area_2d_body_entered(body):
	GameManager.incraseCounter()
	collectHandler()
