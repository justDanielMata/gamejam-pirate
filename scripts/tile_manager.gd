extends TileMap

var GridSize = Vector2(4,4)
var Dic = {}
var player_tile

func _ready():
	var temp_tile_type
	for x in GridSize.x:
		for y in GridSize.y:
			if x < 4:
				temp_tile_type = "player_area"
			else:
				temp_tile_type = "enemies_area"
			Dic[str(Vector2(x,y))] = {
				"type": temp_tile_type
			}
			
			set_cell(0, Vector2(x,y), 1, Vector2i(0,0), 0)

func _process(delta):
	pass
	#var player_tile = local_to_map(player.global_position)
