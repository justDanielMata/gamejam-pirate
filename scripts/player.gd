class_name Player extends Area2D

@export var stats:  CharacterStats : set = set_character_stats

var tile_size = Vector2(150,100)
var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

var animation_speed = 8
var moving = false
var invulnerable = false
var matrixPosition: Vector2

@onready var tile_map: Tiles = %TileMap as Tiles
@onready var ray = $RayCast2D
@onready var stats_ui: StatsUI = $StatsUI as StatsUI
@onready var sprite_2d = $AnimatedSprite2D


func set_character_stats(value: CharacterStats) -> void:
	stats = value
	
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
	
	update_player()

func update_player() -> void:
	if not stats is CharacterStats:
		return
	if not is_inside_tree():
		await ready
	
	update_stats()
	
func update_stats() -> void:
	stats_ui.update_stats(stats)

func take_damage(damage: int) -> void:
	if invulnerable:
		invulnerable = false
		return 
	if stats.health <= 0:
		return
	
	stats.take_damage(damage)
	
	if stats.health <= 0:
		Events.player_died.emit()
		queue_free()

func set_vulnerable() -> void:
	stats.vulnerable = true

func _ready():
	Events.enemy_moved.connect(_get_enemies_range)

func _process(delta):
	pass
	#position = position.snapped(Vector2.ONE * tile_size)
	#position += Vector2.ONE * tile_size/2

func _unhandled_input(event):
	if moving:
		return
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

func move(dir):
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		if stats.moves_per_turn <= 0:
			return
		stats.moves_per_turn -= 1
		#position += inputs[dir] * tile_size
		var tween = create_tween()
		tween.tween_property(self, "position",
			position + inputs[dir] *    tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_SINE)
		moving = true
		await tween.finished
		moving = false
		Events.player_moved.emit()
		_get_enemies_range()

func _get_enemies_range(_enemy = Node):
	var path_to_enemy
	var enemies = get_tree().get_nodes_in_group("enemies")
	#clear groups
	for e in get_tree().get_nodes_in_group("enemies_in_melee_range"):
		e.remove_from_group("enemies_in_melee_range")
	for e in get_tree().get_nodes_in_group("enemies_in_range"):
		e.remove_from_group("enemies_in_range")
	for en in enemies:
		path_to_enemy = tile_map.get_path_to_target(self, en)
		if path_to_enemy.size() < 1:
			en.add_to_group("enemies_in_melee_range")
			en.add_to_group("enemies_in_range")
		if path_to_enemy.size() < 4:
			en.add_to_group("enemies_in_range")
