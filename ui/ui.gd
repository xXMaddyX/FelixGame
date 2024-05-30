extends CanvasLayer

@onready var label = $Label
# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = "X 0"
	GameManager.connect("updateUI", updateUI)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func updateUI(meetCounter):
	label.text = "X " + str(meetCounter)
