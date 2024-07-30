class_name Hand extends HBoxContainer

@export var char_stats: CharacterStats

@onready var card_ui = preload("res://scenes/card_ui/card_ui.tscn")

func _ready():
	Events.reparent_requested.connect(_on_card_ui_reparent_requested)
	Events.add_fused_card_to_hand.connect(add_card)

func add_card(card:Card) -> void:
	var new_card_ui := card_ui.instantiate()
	add_child(new_card_ui)
	new_card_ui.card = card
	new_card_ui.parent = self
	new_card_ui.char_stats = char_stats
	
func disable_hand() -> void:
	for card in get_children():
		card.disabled = true

func _on_card_ui_reparent_requested(child: CardUI, new_parent: String) -> void:
	if not new_parent == 'hand':
		return	
	child.reparent(self)
	var new_index := clampi(child.original_index, 0, get_child_count())
	move_child.call_deferred(child, new_index)

func children() -> int:
	return get_child_count()

