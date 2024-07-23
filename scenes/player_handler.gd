class_name PlayerHandler extends Node

const HAND_DRAW_INTERVAL := 0.25

@export var hand: Hand
var character: CharacterStats

func _ready() -> void:
	Events.card_played.connect(_on_card_played)

func start_battle(char_stats: CharacterStats) -> void:
	character = char_stats
	character.draw_pile = character.deck.duplicate(true)
	character.draw_pile.shuffle()
	character.discard = CardPile.new()
	start_turn()

func start_turn() -> void:
	character.reset_mana()
	character.reset_moves()
	var cards_to_draw = character.cards_per_turn - hand.children()
	if cards_to_draw == 0:
		Events.player_hand_drawn.emit()
	else:
		draw_cards(cards_to_draw)

func end_turn() -> void:
	hand.disable_hand()
	
		
func draw_card() -> void:
	reshuffle_deck_from_discard()
	hand.add_card(character.draw_pile.draw_card())
	reshuffle_deck_from_discard()

func draw_cards(amount: int) -> void:
	var tween := create_tween()
	for i in range(amount):
		tween.tween_callback(draw_card)
		tween.tween_interval(HAND_DRAW_INTERVAL)
		
	tween.finished.connect(
		func(): Events.player_hand_drawn.emit()
	)

func reshuffle_deck_from_discard() -> void:
	if not character.draw_pile.empty():
		return
	while not character.discard.empty():
		character.draw_pile.add_card(character.discard.draw_card())

	character.draw_pile.shuffle()
	
func _on_card_played(card: Card) -> void:
	character.discard.add_card(card)
