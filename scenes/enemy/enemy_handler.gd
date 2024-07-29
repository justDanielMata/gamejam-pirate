class_name EnemyHandler extends Node2D

func _ready() -> void:
	Events.enemy_action_completed.connect(_on_enemy_action_completed)

func reset_enemy_actions() -> void:
	var enemy: Enemy
	for child in get_children():
		enemy = child as Enemy
		enemy.current_action = null
		enemy.update_action()

func start_turn() -> void:
	var enemy: Enemy

	if get_child_count() == 0:
		return
	for child in get_children():
		enemy = child as Enemy
		enemy.stats.reset_moves()
		if enemy.stats.burning:
			enemy.take_damage(1)
			enemy.stats.reset_burning()
	var first_enemy: Enemy = get_child(0) as Enemy
	first_enemy.do_turn()
	
	
func _on_enemy_action_completed(enemy: Enemy) -> void:
	if enemy.get_index() == get_child_count() -1:
		Events.enemy_turn_ended.emit()
		return
	
	var next_enemy: Enemy = get_child(enemy.get_index() + 1) as Enemy
	next_enemy.do_turn()
	
func clear_enemy_statuses() -> void:
	var enemy: Enemy
	for child in get_children():
		enemy = child as Enemy
		enemy.stats.reset_stunned()
