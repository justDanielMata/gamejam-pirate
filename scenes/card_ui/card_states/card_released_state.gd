extends CardState

var played: bool

func enter() -> void:
	played = false
	
	if not card_ui.targets.is_empty():
		if card_ui.target_is_fusion_area():
			transition_requested.emit(self, CardState.State.FUSING)
		else:
			played = true
			card_ui.play()
		Events.tooltip_hide_requested.emit()
		

func on_input(_event: InputEvent) -> void:
	if played:
		return
	transition_requested.emit(self, CardState.State.BASE)

