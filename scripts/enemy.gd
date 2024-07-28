class_name Enemy extends Area2D

@export var stats: EnemyStats : set = set_enemy_stats
@export var bullet:PackedScene
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var stats_ui: StatsUI = $StatsUI as StatsUI
@onready var intent_ui: IntentUI = $IntentUI as IntentUI
@onready var tile_map: Tiles = %TileMap as Tiles

var needs_to_wait := false
var enemy_action_picker: EnemyActionPicker
var matrixPosition: Vector2
var current_action: EnemyAction : set = set_current_action
var moving
var prepped_action: EnemyAction

func _ready():
	Events.enemy_moved.emit(self)

func set_current_action(value: EnemyAction) -> void:
	current_action = value
	if current_action:
		intent_ui.update_intent(current_action.intent)

func set_enemy_stats(value: EnemyStats) -> void:
	stats = value.create_instance()

	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
		stats.stats_changed.connect(update_action)
		print("signals connected")
		
	update_enemy()

func setup_ai() -> void:
	if enemy_action_picker:
		enemy_action_picker.queue_free()
		
	var new_action_picker: EnemyActionPicker = stats.ai.instantiate()
	add_child(new_action_picker)
	enemy_action_picker = new_action_picker
	enemy_action_picker.enemy = self

func update_stats() -> void:
	stats_ui.update_stats(stats)

func update_action() -> void:
	if not enemy_action_picker:
		return
	
	if not current_action:
		current_action = enemy_action_picker.get_action()

	var new_conditional_action := enemy_action_picker.get_first_conditional_action()
	if new_conditional_action and current_action != new_conditional_action:
		current_action = new_conditional_action

func update_enemy() -> void:
	if not stats is Stats:
		return
	
	if not is_inside_tree():
		await ready
	
	sprite_2d.texture = stats.art
	setup_ai()
	update_stats()

func do_turn() -> void:
	if stats.vulnerable:
		stats.vulnerable = false
	var player = get_tree().get_nodes_in_group("player")[0]
	needs_to_wait = false
	var path_to_player = tile_map.get_path_to_target(self, player)
	# check if enemy needs to move
	if path_to_player.size() > stats.range:
		for point in path_to_player:
			if stats.moves_per_turn <= 0:
				break
			tile_map.remove_solid(self.global_position)
			var tween = create_tween()
			tween.tween_property(self, "global_position",
				point, 1.0/8).set_trans(Tween.TRANS_SINE)
			moving = true
			await tween.finished
			Events.enemy_moved.emit(self)
			moving = false
			stats.moves_per_turn -= 1
	# get new path
	path_to_player = tile_map.get_path_to_target(self, player)
	# player is still out of range so we wait
	if path_to_player.size() > stats.range or path_to_player.is_empty():
		Events.enemy_action_completed.emit(self)
	else:
		update_action()
		if not current_action:
			return
		
		
		current_action.perform_action()
	
func take_damage(damage: int) -> void:
	if stats.health <= 0:
		return
	
	stats.take_damage(damage)
	
	if stats.health <= 0:
		queue_free()

func set_vulnerable() -> void:
	stats.vulnerable = true
