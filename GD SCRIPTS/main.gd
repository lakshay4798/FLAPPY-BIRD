extends Node2D

var is_locked_up = false
var score = 0
var total_crashes = 0
var total_pipes = 0
const FLAP_FORCE = -300.0

@onready var click : AudioStreamPlayer2D = $CLICK
@onready var background2 : Node2D = $background2
@export var pipe_scene: PackedScene
@onready var hit_sound : AudioStreamPlayer2D = $HIT
@onready var die_sound : AudioStreamPlayer2D = $DIE
@onready var  WIN : Label = $WIN
@onready var gameover : Sprite2D = $CanvasLayer/gameover
@onready var faah : AudioStreamPlayer2D = $FAAH
@onready var button : Button = $CanvasLayer/Button
@onready var high_score_label : Label = $CanvasLayer2/HighScoreLabel

func _ready() -> void:
	print(HighScore.high_score)
	high_score_label.text = "Best: " + str(HighScore.high_score)

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_R):
		total_crashes = 0
		print(total_crashes)
		get_tree().reload_current_scene()
	
	elif Input.is_key_pressed(KEY_C):
		background2.visible = true
	
	elif Input.is_key_pressed(KEY_X):
		background2.visible = false
		
	elif Input.is_key_pressed(KEY_TAB):
		get_tree().change_scene_to_file("res://TSCN FILE/start.tscn")
		


func _on_pipetimer_timeout() -> void:
	var new_pipe = pipe_scene.instantiate()
	total_pipes +=1

	# 1. Spawn just off the right edge of your 512-wide screen
	new_pipe.position.x = 550.0
	
	# 2. Keep the vertical center between 150 and 350 so they don't clip through the ceiling/floor
	new_pipe.position.y = randf_range(150, 300)
	
	# 3. Spawn it into the game world
	add_child(new_pipe)
	
	# 4. Link the hit crash handler
	new_pipe.hit.connect(_on_pipe_hit)


	#if total_pipes == 5:
		#$pipetimer.stop()
		#print("Max pipes reached! Spawning stopped.")
		#await get_tree().create_timer(2.5).timeout
		#print("YOU WIN") 
		#WIN.visible = true                             
		#return 

##background change when somme point you want to change
	if total_pipes == 25:
		await get_tree().create_timer(2.5).timeout
		background2.visible = true
	elif total_pipes == 50:
		await get_tree().create_timer(2).timeout
		background2.visible = false
		

func _on_pipe_hit() -> void:
	total_crashes +=1
	if total_crashes == 1:
		is_locked_up = true
		$pipetimer.stop()
		#hit_sound.play()
		faah.play(0.25)
		freeze_environment_only()
		
		# 2. THE FIX: Flip the dead flag and give it a small upward bump.
		# Do NOT turn off physics process so gravity can pull it down!
		if has_node("player"):
			var bird = get_node("player")
			bird.is_dead = true
			bird.velocity.y = -150.0
			print("gameover")
			await get_tree().create_timer(0.5).timeout
			
		if score > HighScore.high_score:
			HighScore.high_score = score
			HighScore.save_high_score()
			
			$CanvasLayer2/HighScoreLabel.text = "Best: " + str(HighScore.high_score)
			
			gameover.visible = true
			button.visible = true


	"""if you want three timmes to get chance"""
	#total_crashes +=1
	#print(total_crashes)
	#if total_crashes <= 3:
		#
		#print("Try again")
		#hit_sound.play()
	#else:
		#print("died")
		#if has_node("player"):
			#get_node("player").set_physics_process(false)
			##get_node("player").velocity = Vector2.ZERO
			#gameover.visible = true
		#if has_node("ground"):
			#get_node("ground").set_process(false)
	
		#die_sound.play()
	
	## Reloads the current scene instantly to let the player try again
		#await get_tree().create_timer(1).timeout
		#get_tree().reload_current_scene() 
		

func add_score() -> void:
	if not is_locked_up:
		score += 1
		$POINT.play() # Plays your sound effect
		$ScoreLabel.text = str(score)


func freeze_environment_only() -> void:
	if has_node("ground"):
		get_node("ground").set_process(false)
	for child in get_children():
		if "pipe" in child.name.to_lower():
			child.set_process(false)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://TSCN FILE/main.tscn")


func _on_groundstop_body_entered(body: Node2D) -> void:
	faah.play(0.25)
	await get_tree().create_timer(0.4).timeout
	gameover.visible = true
	button.visible = true


func _on_back_pressed() -> void:
	click.play()
	#await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://TSCN FILE/start.tscn")


func _on_resume_pressed() -> void:
	get_tree().paused = false
	$PAUSE/Button.visible = false
