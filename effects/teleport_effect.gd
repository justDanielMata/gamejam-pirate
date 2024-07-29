class_name TeleportEffect extends Effect

var toCoords: Vector2i

func execute(targets: Array[Node]) -> void:
	for target in targets:
		if not target:
			continue
		if target is Enemy or target is Player:
			target.global_position  = toCoords
