extends StaticBody2D 

func _ready() -> void:
	Events.enemy_turn_ended.connect(
		func(): queue_free()
	)
