extends CharacterBody2D

const SPEED = 200
var direction = 0  # Richtung des Schusses
var OrigX = 0
var ballLight
var lightOn = false
var lightToggel = false
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $AnimatedSprite2D/Area2D/CollisionShape2D
@onready var fireball_light = $fireballLight

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.x = direction * SPEED
	animated_sprite_2d.play("ShotAnim")
	OrigX = position.x
	
func destroy():
	queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if direction == -1:
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.position.x = 0
	velocity.x = direction * SPEED
	move_and_slide()
	
	if position.x > OrigX + 400:
		queue_free()
	
	if lightOn and !lightToggel:
		fireball_light.enabled = true
		lightToggel = true


func _on_area_2d_body_entered(body):
	destroy()
	body.takeDamage()
