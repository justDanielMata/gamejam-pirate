extends StaticBody2D 

@export var solid_point: Vector2i

func _ready() -> void:
	Events.enemy_turn_ended.connect(
		func(): get_parent().destroy_rock(self)
	)
