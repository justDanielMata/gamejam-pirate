extends Card

func apply_effects(targets: Array[Node]) -> void:
	var tile_map = targets[0]
	var targeted_tile = tile_map.get_current_targeted_tile()
	tile_map.set_point_solid(targeted_tile)
	tile_map.summon_rock(targeted_tile)
