class_name EnemyStats extends Stats

@export var ai: PackedScene
@export var range: int
@export var max_moves: int

func reset_moves() -> void:
	self.moves_per_turn = max_moves

func reset_burning() -> void:
	self.burning = false

func reset_stunned() -> void:
	self.stunned = false
