class_name MovesUI extends Panel

@export var char_stats: CharacterStats : set = _set_char_stats

@onready var moves_label: Label = $MovesLabel

func _set_char_stats(value:CharacterStats) -> void:
	char_stats = value
	
	if not char_stats.stats_changed.is_connected(_on_stats_changed):
		char_stats.stats_changed.connect(_on_stats_changed)
	
	if not is_node_ready():
		await ready
	
	_on_stats_changed()
	
func _on_stats_changed() -> void:
	moves_label.text = "%s/%s" % [char_stats.moves_per_turn, char_stats.max_moves]
	
	
	
