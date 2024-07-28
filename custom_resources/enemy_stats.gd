class_name EnemyStats extends Stats

@export var ai: PackedScene
@export var range: int
@export var max_moves: int

func reset_moves() -> void:
	self.moves_per_turn = max_moves
