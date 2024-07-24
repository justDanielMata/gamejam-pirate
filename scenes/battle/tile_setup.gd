class_name Tiles extends TileMap

@onready var player = $"../Player"
@onready var melee = $"../EnemyHandler/Melee"

var astar_grid = AStarGrid2D.new()
var start
var end

func initialize_grid():
	var tilemap_size = get_used_rect().end - get_used_rect().position
	var map_rect = Rect2i(Vector2i.ZERO, tilemap_size)
	var tile_size = get_tileset().tile_size
	
	astar_grid.region = map_rect
	astar_grid.cell_size = tile_size
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	astar_grid.offset = tile_size / 2
	astar_grid.update()
	pass

func _ready() -> void:
	initialize_grid()	
	Events.player_moved.connect(_on_player_moved)
	Events.enemy_moved.connect(_on_enemy_moved)



func _on_player_moved() -> void:
	pass
		

func _on_enemy_moved(enemy: Enemy) -> void:
	astar_grid.set_point_solid(local_to_map(to_local(enemy.global_position)))

func get_path_to_player(enemy: Enemy) -> PackedVector2Array: 
	var path = astar_grid.get_id_path(
		local_to_map(to_local(enemy.global_position)),
		local_to_map(to_local(player.global_position))
	).slice(1)
	var normalized_path = []
	for p in path:
		normalized_path.append(to_global(map_to_local(p)))
	normalized_path.pop_back()
	return PackedVector2Array(normalized_path)
		
	
