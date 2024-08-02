extends CardState

func enter() -> void:
	if not card_ui.is_node_ready():
		await card_ui.ready
	
	if card_ui.tween and card_ui.tween.is_running():
		card_ui.tween.kill()

	Events.reparent_requested.emit(card_ui, "hand")
	card_ui.pivot_offset = Vector2.ZERO
	
	Events.tooltip_hide_requested.emit()
	
func on_gui_input(event: InputEvent) -> void:
	if not card_ui.playable or card_ui.disabled:
		return 

	if event.is_action_pressed("left_mouse"):
		card_ui.pivot_offset = card_ui.get_global_mouse_position() - card_ui.global_position
		transition_requested.emit(self, CardState.State.CLICKED)
		
func on_mouse_entered() -> void:
	if not card_ui.playable or card_ui.disabled:
		return
	Events.card_tooltip_requested.emit(card_ui.card.icon, card_ui.card.tooltip_text)
	
func on_mouse_exited() -> void:
	if not card_ui.playable or card_ui.disabled:
		return
	Events.tooltip_hide_requested.emit()
