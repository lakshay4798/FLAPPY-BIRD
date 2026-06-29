#extends Area2D
#
#signal hit
#
#
#
#func _on_body_entered(body: Node2D) -> void:
	#hit.emit()
	#
extends Node2D


signal hit

@export var speed: float = 200.0
@export var despawn_x: float = -100.0

func _process(delta: float) -> void:
	if get_tree().current_scene.is_locked_up:
		return

	position.x -= speed * delta
	if position.x < despawn_x:
		queue_free()

# This function triggers when a pipe's Area2D detects the bird
func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		hit.emit()
		

func _on_score_area_body_entered(body: Node2D) -> void:
	if body.name == "player":
		# Get the main world scene and play the POINT sound node directly!
		#get_tree().current_scene.get_node("POINT").play()
		get_tree().current_scene.add_score()
		
