extends Node

var meetCounter = 0

func incraseCounter():
	meetCounter += 1
	emit_signal("updateUI", meetCounter)

signal  updateUI(meetCounter)
