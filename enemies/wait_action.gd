extends EnemyAction

func is_performable() -> bool:
	return enemy.needs_to_wait
	
func perform_action() -> void:
	Events.enemy_action_completed.emit(enemy)
	
