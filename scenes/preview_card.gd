class_name PreviewCard extends Control

@onready var panel: Panel = $Panel
@onready var icon: TextureRect = $TextureRect
@onready var card_name: Label = $CardName
@export var card: Card : set = _set_card

var parent: Control
func draw() -> void:
	if not card:
		return
	queue_free()

func _set_card(value: Card) -> void:
	if not is_node_ready():
		await ready
	
	card = value
	icon.texture = card.icon
	card_name.text = str(card.id)

func _on_mouse_entered() -> void:
	Events.card_tooltip_requested.emit(card.icon, card.tooltip_text)
	pass

func _on_mouse_exited() -> void:
	Events.tooltip_hide_requested.emit()
	pass
