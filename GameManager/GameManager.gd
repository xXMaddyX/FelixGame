extends Node

var meetCounter = 0
var DinoPowerState = "Normal"

func incraseCounter():
	meetCounter += 1
	emit_signal("updateUI", meetCounter)
	
func changeDinoPowerState(power):
	DinoPowerState = power
	
func updateDinoPowerState():
	emit_signal("updateDinoPower", DinoPowerState)
	
func resetMeetCounter():
	meetCounter = 0
	
signal updateDinoPower(power)
signal updateUI(meetCounter)
