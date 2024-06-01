extends CharacterBody2D

const SPEED = 200
var direction = 0  # Richtung des Schusses
var OrigX = 0
var isHit = false
@onready var ice_shot_anim = $iceShotAnim
@onready var collision_shape_2d = $Area2D/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.x = direction * SPEED
	OrigX = position.x
	ice_shot_anim.play("shotStart")
	await get_tree().create_timer(0.2).timeout
	ice_shot_anim.play("shotInFlight")
	
func destroy():
	queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if direction == -1:
		ice_shot_anim.flip_h = true
		ice_shot_anim.position.x = 0
	if isHit == false:
		velocity.x = direction * SPEED
		
	if isHit:
		velocity.x = 0
	move_and_slide()
	
	if position.x > OrigX + 400:
		queue_free()


func _on_area_2d_body_entered(body):
	body.takeDamage()
	ice_shot_anim.play("shotHit")
	isHit = true
	await get_tree().create_timer(0.7).timeout
	destroy()
