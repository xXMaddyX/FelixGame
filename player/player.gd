extends CharacterBody2D

const SPEED = 120.0
const DASH_SPEED = 200.0
const JUMP_VELOCITY = -400.0
var hp = 3
var isHit = false
var isDead = false
var direction = 1
var dash = false
const Powers = {
	"Normal": {
		"Run": "run",
		"Idle": "idle",
		"Jump": "jump",
		"GetHit": "gethit",
		"Dash": "dash",
	},
	"Fire": {
		"Run": "redRun",
		"Idle": "redIdle",
		"Jump": "redJump",
		"Gethit": "redGethit",
		"Dash": "redDash",
	},
	"Water": {
		"Run": "waterRun",
		"Idle": "waterIdle",
		"Jump": "waterJump",
		"Gethit": "waterGethit",
		"Dash": "waterDash",
	}
}

#Powers
var Fire = false
var Normal = true
var Water = false
var actualPower = Powers["Normal"]


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	switchPowers("Normal")
	GameManager.connect("updateDinoPower", switchPowers)

func animationHandler(powerState):
	if isHit:
		animated_sprite_2d.play(powerState["GetHit"])
	if dash and not isHit and is_on_floor():
		animated_sprite_2d.play(powerState["Dash"])
	elif direction == 1 and not isHit and is_on_floor():
		animated_sprite_2d.play(powerState["Run"])
	elif direction == -1 and not isHit and is_on_floor():
		animated_sprite_2d.play(powerState["Run"])
	elif direction == 0 and not isHit and is_on_floor():
		animated_sprite_2d.play(powerState["Idle"])
		
func switchPowers(power):
		print(power)
		if power == "Fire":
			Normal = false
			Fire = true
			Water = false
			actualPower = Powers["Fire"]
		elif power == "Normal":
			Normal = true
			Fire = false
			Water = false
			actualPower = Powers["Normal"]
		elif power == "Water":
			Normal = false
			Fire = false
			Water = true
			actualPower = Powers["Water"]

func takeDamage():
	if not isHit:
		isHit = true
		hp -= 1
		switchPowers("Normal")
		await get_tree().create_timer(1).timeout
		isHit = false
		
func restart_scene():
	get_tree().reload_current_scene()
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		animated_sprite_2d.play(actualPower["Jump"])

	if Input.is_action_pressed("dash") and is_on_floor() and not direction == 0:
		dash = true
	else:
		dash = false

	# Handle movement.
	if dash:
		velocity.x = direction * DASH_SPEED
	elif Input.is_action_pressed("move_left") and not isHit:
		animated_sprite_2d.flip_h = true
		direction = -1
		velocity.x = direction * SPEED
	elif Input.is_action_pressed("move_right") and not isHit:
		animated_sprite_2d.flip_h = false
		direction = 1
		velocity.x = direction * SPEED
	else:
		direction = 0
		velocity.x = 0
	
	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if hp < 0:
		isDead = true
		
	if isDead:
		restart_scene()
	
	animationHandler(actualPower)

	move_and_slide()
