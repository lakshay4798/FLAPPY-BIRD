extends Node2D
@onready var click : AudioStreamPlayer2D = $CLICK
@onready var sprite2d : Sprite2D = $Sprite2D
@onready var sprite2d2 : Sprite2D = $Sprite2D2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_SPACE):
		get_tree().change_scene_to_file("res://TSCN FILE/main.tscn")
	

func _on_button_pressed() -> void:
	click.play()
	sprite2d.visible = false
	sprite2d2.visible = true
	await  get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://TSCN FILE/main.tscn")
