extends CardState

func enter() -> void:
	card_ui.targets.clear()
	card_ui.drop_point_detector.monitoring = false
	Events.reparent_requested.emit(card_ui, "fusion")
	
func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("right_mouse"):
		transition_requested.emit(self, CardState.State.BASE)
		Events.reparent_requested.emit(card_ui, "hand")
