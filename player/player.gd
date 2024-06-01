extends CharacterBody2D

const SPEED = 120.0
const DASH_SPEED = 200.0
const JUMP_VELOCITY = -400.0
var hp = 3
var isHit = false
var isDead = false
var direction = 1
var shotDirection = 1
var dash = false
var deadseq = false
var shotFired = false
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
@onready var playerCollider = $CollisionShape2D
const FIRE_BALL = preload("res://player/fireBall.tscn")
const ICE_SHOT = preload("res://player/IceShot.tscn")


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
	
func checkShotPower():
	if Normal:
		return
	elif Fire:
		var shot = FIRE_BALL.instantiate()
		if shotDirection == 1:
			shot.position = global_position
			shot.position.y += 0
			shot.position.x += 60 
		if shotDirection == -1:
			shot.position = global_position
			shot.position.y += 0
			shot.position.x -= 30
			
		shot.direction = shotDirection
		get_tree().root.add_child(shot)
	elif Water:
		var shot = ICE_SHOT.instantiate()
		if shotDirection == 1:
			shot.position = global_position
			shot.position.y += 0
			shot.position.x += 30
		if shotDirection == -1:
			shot.position = global_position
			shot.position.y += 0
			shot.position.x -= 30
			
		shot.direction = shotDirection
		get_tree().root.add_child(shot)
		pass
	
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		animated_sprite_2d.play(actualPower["Jump"])

	if Input.is_action_pressed("dash") and not direction == 0:
		dash = true
	else:
		dash = false

	# Handle movement.
	if dash:
		velocity.x = direction * DASH_SPEED
	elif Input.is_action_pressed("move_left") and not isHit:
		animated_sprite_2d.flip_h = true
		direction = -1
		shotDirection = -1
		velocity.x = direction * SPEED
	elif Input.is_action_pressed("move_right") and not isHit:
		animated_sprite_2d.flip_h = false
		direction = 1
		shotDirection = 1
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
		playerCollider.disabled = true
		set_collision_layer(0)
		set_collision_mask(0)
		deadseq = true
		GameManager.resetMeetCounter()
	
	animationHandler(actualPower)
		
	move_and_slide()

	if Input.is_action_pressed("fire") and not shotFired:
		shotFired = true
		checkShotPower()
		await get_tree().create_timer(1).timeout
		shotFired = false
		
	if deadseq:
		await get_tree().create_timer(3).timeout
		restart_scene()
		
