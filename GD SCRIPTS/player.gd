
extends CharacterBody2D

const GRAVITY = 900.0
const FLAP_FORCE = -300.0
var is_dead: bool = false
#var game_started: bool = false

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var wing_sound : AudioStreamPlayer2D = $WING
#@onready var hit_sound : AudioStreamPlayer2D = $HIT

func _ready():
	animated_sprite_2d.play("idle")

func _physics_process(delta):
	# Gravity (Only pulls the bird down if the game has started!)
	#if game_started:
	velocity.y += GRAVITY * delta
		
	# Flap (Only works if spacebar is tapped AND the bird isn't dead)
	#if not is_dead and Input.is_action_just_pressed("ui_accept"):
	if Input.is_action_just_pressed("ui_accept"):
		#game_started = true # The very first tap wakes up gravity!
			velocity.y = FLAP_FORCE
			wing_sound.play()

	move_and_slide()

	# Rotate bird slightly
	if velocity.y < 0:
		rotation = deg_to_rad(-10)
	elif velocity.y > 0:
		rotation = deg_to_rad(10)
	else:
		pass
		
