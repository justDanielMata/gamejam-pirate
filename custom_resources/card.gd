class_name Card extends Resource

enum Type {ATTACK, DEFEND}
enum Kind {BASE, FUSED}
enum Target {SELF, MELEE_ENEMY, RANGED_ENEMY, EMPTY_TILE, ALL_ENEMIES}

@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var target: Target
@export var mana_cost: int
@export var kind: Kind
@export var fusion_result:= {}
@export var base_cards: Array[Card]

@export_group("Card Visuals")
@export var icon: Texture
@export_multiline var tooltip_text: String 

func is_card_basic() -> bool:
	return kind == Kind.BASE

func is_targeted() -> bool:
	return target == Target.MELEE_ENEMY or target == Target.RANGED_ENEMY or target == Target.EMPTY_TILE

func target_melee() -> bool:
	return target == Target.MELEE_ENEMY

func target_ranged() -> bool:
	return target == Target.RANGED_ENEMY

func target_tile() -> bool:
	return target == Target.EMPTY_TILE

func _get_targets(targets: Array[Node]) -> Array[Node]:
	if not targets:
		return []
	var tree := targets[0].get_tree()

	match target:
		Target.SELF:
			return tree.get_nodes_in_group("player")
		Target.ALL_ENEMIES:
			return tree.get_nodes_in_group("enemies")
		Target.MELEE_ENEMY:
			return tree.get_nodes_in_group("enemies_in_melee_range")
		Target.RANGED_ENEMY:
			if not targets[0].is_in_group("enemies_in_range"):
				return []
			return [targets[0]]
		Target.EMPTY_TILE:
			return targets # this will be the tilemap
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

func get_fusion_result(card_to_fuse: Card) -> Card:
	return self.fusion_result[card_to_fuse.id]

func get_base_cards() -> Array[Card]:
	return self.base_cards
