class_name Card extends Resource

enum Type {ATTACK, DEFEND}
enum Target {SELF, MELEE_ENEMY, RANGED_ENEMY, EMPTY_TILE}

@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var target: Target
@export var mana_cost: int

@export_group("Card Visuals")
@export var icon: Texture
@export_multiline var tooltip_text: String 

func is_targeted() -> bool:
	return target == Target.MELEE_ENEMY or target == Target.RANGED_ENEMY or target == Target.EMPTY_TILE

func target_melee() -> bool:
	return target == Target.MELEE_ENEMY

func target_ranged() -> bool:
	return target == Target.RANGED_ENEMY


func _get_targets(targets: Array[Node]) -> Array[Node]:
	if not targets:
		return []
	var tree := targets[0].get_tree()

	match target:
		Target.SELF:
			return tree.get_nodes_in_group("player")
		Target.MELEE_ENEMY:
			return tree.get_nodes_in_group("enemies_in_melee_range")
		Target.RANGED_ENEMY:
			if not targets[0].is_in_group("enemies_in_range"):
				return []
			return tree.get_nodes_in_group("enemies_in_range")
		_:
			return []

func play(targets: Array[Node], char_stats: CharacterStats) -> void:
	var selected = _get_targets(targets)
	if selected.size() == 0:
		Events.card_canceled.emit(self)
	Events.card_played.emit(self)
	
	apply_effects(selected)

func apply_effects(_targets: Array[Node]) -> void:
	pass
