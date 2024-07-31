class_name NextCardContainer extends VBoxContainer

const PREVIEW_CARD = preload("res://scenes/preview_card.tscn")

@export var char_stats: CharacterStats

func _ready() -> void:
	Events.next_card_changed.connect(_on_next_card_changed)
	
func _on_next_card_changed(card:Card) -> void:
	for card_ui in get_children():
		card_ui.queue_free()
	var new_card_ui := PREVIEW_CARD.instantiate()
	add_child(new_card_ui)
	new_card_ui.card = card
	new_card_ui.parent = self
