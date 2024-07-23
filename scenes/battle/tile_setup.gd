extends TileMap

var gridSize = Vector2(4,4)
var cellSize = 100
var Dic = {}
@onready var player = $"../Player"

func _ready() -> void:
	for x in gridSize.x:
		for y in gridSize.y:
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

func _on_enemy_moved(enemy: Enemy) -> void:
	var tile = local_to_map(self.to_local(enemy.global_position))
	enemy.matrixPosition = tile
	Dic.get(str(tile)).contents = [enemy]
