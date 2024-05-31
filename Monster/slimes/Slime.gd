extends CharacterBody2D


const SPEED = 40.0
var direction = 1
var isDead = false
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var check_right = $checkRight
@onready var check_left = $checkLeft
@onready var explosion = $explosion

func _ready():
	explosion.hide()

func animationHandler():
	if direction == 1 and not isDead:
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("run")
	elif direction == -1 and not isDead:
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("run")
		
func moveHandler():
	if direction == 1 and not isDead:
		velocity.x = direction * SPEED
	elif direction == -1 and not isDead:
		velocity.x = direction * SPEED
		
func checkCollition():
	if check_right.is_colliding():
		direction = -1
	if check_left.is_colliding():
		direction = 1
	
func takeDamage():
	isDead = true
	velocity.x = 0
	explosion.show()
	explosion.play("explosion")
	animated_sprite_2d.hide()
	await get_tree().create_timer(0.8).timeout
	queue_free()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	animationHandler()
	checkCollition()
	moveHandler()
	move_and_slide()

func _on_area_2d_body_entered(body):
	if not isDead:
		body.takeDamage()
