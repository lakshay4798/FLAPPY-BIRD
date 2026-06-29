extends Sprite2D

@export var speed: float = 150.0

func _process(delta: float) -> void:
	# This shifts the texture wrapper coordinates infinitely to the right,
	# making the visual ground look like it is moving left!
	region_rect.position.x += speed * delta
