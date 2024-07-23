extends TileMap

var grid_size = Vector2(4,4)
var cell_size = Vector2i(100,100)
var Dic = {}

var astar_grid = AStarGrid2D.new()
@onready var line_2d = $Line2D

@onready var player = $"../Player"
@onready var melee = $"../EnemyHandler/Melee"

var start
var end

func initialize_grid():
	astar_grid.size = grid_size
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	astar_grid.cell_size = cell_size
	astar_grid.offset = cell_size / 2
	astar_grid.update()

func _ready() -> void:
	initialize_grid()
	for x in grid_size.x:
		for y in grid_size.y:
			Dic[str(Vector2(x,y))] = {
				"coordinates": "%s, %s" % [x,y],
				"contents": []
			}
			set_cell(0, Vector2(x,y), 3, Vector2i(0,0), 0)
	print(Dic)
	Events.player_moved.connect(_on_player_moved)
	Events.enemy_moved.connect(_on_enemy_moved)



func _on_player_moved() -> void:
	var tile = local_to_map(self.to_local(player.global_position))
	player.matrixPosition = tile
	Dic.get(str(tile)).contents = [player]
	start = local_to_map(self.to_local(player.global_position))
	end = local_to_map(self.to_local(melee.global_position))
	if start != null and end != null:
		print(astar_grid.get_id_path(start, end))
		

func _on_enemy_moved(enemy: Enemy) -> void:
	var tile = local_to_map(self.to_local(enemy.global_position))
	enemy.matrixPosition = tile
	Dic.get(str(tile)).contents = [enemy]
	end = local_to_map(self.to_local(melee.global_position))
	if start and end:
		line_2d.points = PackedVector2Array(astar_grid.get_point_path(start, end))
