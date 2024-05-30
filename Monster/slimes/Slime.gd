extends CharacterBody2D


const SPEED = 40.0
var direction = 1
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var check_right = $checkRight
@onready var check_left = $checkLeft


func animationHandler():
	if direction == 1:
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("run")
	elif direction == -1:
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("run")
		
func moveHandler():
	if direction == 1:
		velocity.x = direction * SPEED
	elif direction == -1:
		velocity.x = direction * SPEED
		
func checkCollition():
	if check_right.is_colliding():
		direction = -1
	if check_left.is_colliding():
		direction = 1
	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	
	animationHandler()
	checkCollition()
	moveHandler()
	move_and_slide()


func _on_area_2d_body_entered(body):
	body.takeDamage()
