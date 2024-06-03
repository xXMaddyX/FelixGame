extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0
var direction = 1
var isIdle = false
var idle_timer = 0.0
var isDead = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var fire_monster_anim = $FireMonsterAnim
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var explosion = $Explosion
@onready var check_left = $checkLeft
@onready var check_right = $checkRight

@onready var point_light_2d = $PointLight2D


func _ready():
	explosion.hide()

func animationHandler():
	if isIdle and not isDead:
		fire_monster_anim.play("Idle")
	elif not isIdle and not isDead:
		fire_monster_anim.play("move")
	if direction == 1:
		fire_monster_anim.flip_h = true
	if direction == -1:
		fire_monster_anim.flip_h = false

func moveHandler():
	if not isIdle:
		velocity.x = direction * SPEED
	else:
		velocity.x = 0
		
func setLightsOn():
	point_light_2d.enabled = true

func directionHandler():
	if check_left.is_colliding():
		direction = 1
	elif check_right.is_colliding():
		direction = -1

func moveTimer(delta):
	idle_timer -= delta
	if idle_timer <= 0:
		isIdle = not isIdle
		idle_timer = randi_range(5, 10)
		
func takeDamage():
	velocity.x = 0
	isDead = true
	
	fire_monster_anim.hide()
	explosion.show()
	explosion.play("explosion")
	await get_tree().create_timer(0.8).timeout
	queue_free()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	directionHandler()
	animationHandler()
	
	if not isDead:
		moveTimer(delta)
		moveHandler()
		move_and_slide()


func _on_area_2d_body_entered(body):
	if not isDead:
		body.takeDamage()
	if isDead:
		collision_shape_2d.disabled = true
