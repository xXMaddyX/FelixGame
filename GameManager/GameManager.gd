extends Node

var meetCounter = 0
var DinoPowerState = "Normal"

var is_fullscreen = false
var previous_fullscreen_button_state = false

signal updateDinoPower(power)
signal updateUI(meetCounter)

func incraseCounter():
	meetCounter += 1
	emit_signal("updateUI", meetCounter)
	
func changeDinoPowerState(power):
	DinoPowerState = power
	
func updateDinoPowerState():
	emit_signal("updateDinoPower", DinoPowerState)
	
func resetMeetCounter():
	meetCounter = 0
	
func _process(_delta):
	var current_fullscreen_button_state = Input.is_action_pressed("fullscreen")
	
	if current_fullscreen_button_state and !previous_fullscreen_button_state:
		if is_fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			is_fullscreen = false
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			is_fullscreen = true
	
	previous_fullscreen_button_state = current_fullscreen_button_state
