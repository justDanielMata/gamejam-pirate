class_name CharacterStats extends Stats

@export var starting_deck: CardPile
@export var cards_per_turn: int
@export var max_mana: int
@export var max_moves: int

var mana: int : set = set_mana
var moves_per_turn: int: set = set_moves_per_turn
var deck: CardPile
var discard: CardPile
var draw_pile: CardPile

func set_moves_per_turn(value: int) -> void:
	moves_per_turn = value
	stats_changed.emit()
	
func set_mana(value: int) -> void:
	mana = value
	stats_changed.emit()

func reset_moves() -> void:
	self.moves_per_turn = max_moves

func reset_mana() -> void:
	self.mana = max_mana
	
func can_play_card(card: Card) -> bool:
	return mana >= card.mana_cost

func create_instance() -> Resource:
	var instance: CharacterStats = self.duplicate()
	instance.health = max_health
	instance.block = 0
	instance.reset_mana()
	instance.reset_moves()
	instance.deck = instance.starting_deck.duplicate()
	instance.draw_pile = CardPile.new()
	instance.discard = CardPile.new()
	return instance
