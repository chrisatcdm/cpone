extends CharacterBody2D

@export var speed = 100
@export var friction = 0.5
@export var acceleration = 0.1

@onready var animated_sprite = $AnimatedSprite2D

func get_input():
	var input = Vector2()
	if Input.is_action_pressed('move_right'):
		input.x += 1
		animated_sprite.flip_h = false
	if Input.is_action_pressed('move_left'):
		input.x -= 1
		animated_sprite.flip_h = true
	if Input.is_action_pressed('move_down'):
		input.y += 1
	if Input.is_action_pressed('move_up'):
		input.y -= 1
	if input == Vector2.ZERO:
		animated_sprite.play('idle')
	else:
		animated_sprite.play('run')

	return input

func _physics_process(delta):
	var direction = get_input()
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	move_and_slide()
