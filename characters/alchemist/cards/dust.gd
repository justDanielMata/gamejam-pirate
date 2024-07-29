extends Card

func apply_effects(targets: Array[Node]) -> void:
	var tile_map = targets[0]
	var targeted_tile = tile_map.get_current_targeted_tile()
	var teleport_effect = TeleportEffect.new()
	teleport_effect.toCoords = tile_map.to_global(tile_map.map_to_local(targeted_tile))
	teleport_effect.execute([tile_map.player])
