extends EnemyAction

@export var damage := 2
var instanced_bullet

func perform_action():
	if not enemy or not target:
		return
	
	enemy.add_child(enemy.bullet.instantiate())
	instanced_bullet = enemy.get_child(enemy.get_child_count() - 1)
	var tween = create_tween().set_trans(Tween.TRANS_QUINT)
	var start = instanced_bullet.global_position
	var end = target.global_position + Vector2.RIGHT * 32
	var damage_effect := DamageEffect.new()
	var target_array: Array[Node] = [target]
	damage_effect.amount = damage
	
	tween.tween_property(instanced_bullet, "global_position", end, 1)
	tween.tween_callback(damage_effect.execute.bind(target_array))
	tween.finished.connect(
		func():
			instanced_bullet.queue_free()
			Events.enemy_action_completed.emit(enemy)
	)


