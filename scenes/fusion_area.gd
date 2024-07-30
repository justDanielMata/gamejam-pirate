class_name FusionArea extends Area2D

var cards_to_fuse: Array[CardUI] = []
func _ready() -> void:
		Events.reparent_requested.connect(_on_card_ui_reparent_requested)
		
func _on_card_ui_reparent_requested(child: CardUI, new_parent: String) -> void:
	if not new_parent == 'fusion':
		return
	child.reparent(self)


func _on_child_entered_tree(node) -> void:
	if node.is_in_group('cards'):
		cards_to_fuse.append(node)
	if cards_to_fuse.size() == 2:
		fuse_cards()


func _on_child_exiting_tree(node):
	if node.is_in_group('cards'):
		cards_to_fuse.erase(node)

func fuse_cards() -> void:
	var resulting_card = cards_to_fuse[0].card.get_fusion_result(cards_to_fuse[1].card)
	resulting_card.base_cards += [cards_to_fuse[0].card, cards_to_fuse[1].card]
	#Events.card_played.emit(cards_to_fuse[0].card)
	#Events.card_played.emit(cards_to_fuse[1].card)
	for card_ui in cards_to_fuse:
		card_ui.queue_free()
	Events.add_fused_card_to_hand.emit(resulting_card)
