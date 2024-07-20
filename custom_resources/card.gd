class_name Card extends Resource

enum Type {ATTACK, DEFEND}
enum Target {SELF, ENEMY, EMPTY_TILE}

@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var target: Target
@export var mana_cost: int

@export_group("Card Visuals")
@export var icon: Texture
@export_multiline var tooltip_text: String 

func is_targeted() -> bool:
	return target == Target.ENEMY or target == Target.EMPTY_TILE

func _get_targets(targets: Array[Node]) -> Array[Node]:
	if not targets:
		return []
	
	var tree := targets[0].get_tree()
	
	match target:
		Target.SELF:
			return tree.get_nodes_in_group("player")
		Target.ENEMY:
			return tree.get_nodes_in_group("enemies")
		_:
			return []
func play(targets: Array[Node], char_stats: CharacterStats) -> void:
	Events.card_played.emit(self)
	
	apply_effects(_get_targets(targets))

func apply_effects(_targets: Array[Node]) -> void:
	pass
