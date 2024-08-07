extends Node2D


const TILE = preload("res://scenes/tile.tscn")
var gridSize = Vector2(4,4)
var cellSize = 110
var Dic = {}

func _ready() -> void:
	for x in gridSize.x:
		for y in gridSize.y:
			Dic[str(Vector2(x,y))] = {
				"coordinates": "%s, %s" % [x,y],
				"contents": []
			}
			var playerNode = TILE.instantiate()
			add_child(playerNode)
			playerNode.position = Vector2(x,y) * cellSize
			
