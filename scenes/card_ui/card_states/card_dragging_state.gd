extends CardState

const DRAG_MINIMUM_TRESHOLD := 0.05

var minimum_drag_time_elapsed := false

func enter() -> void:
	var ui_layer := get_tree().get_first_node_in_group("ui_layer_group")
	if ui_layer:
		card_ui.reparent(ui_layer)
	Events.card_dragging_started.emit(card_ui)
	minimum_drag_time_elapsed = false
	var treshold_timer := get_tree().create_timer(DRAG_MINIMUM_TRESHOLD, false)
	treshold_timer.timeout.connect(func(): minimum_drag_time_elapsed = true)
	
func on_input(event: InputEvent) -> void:
	var is_targeted := card_ui.card.is_targeted()
	var mouse_motion := event is InputEventMouseMotion
	var cancel = event.is_action_pressed("right_mouse")
	var confirm = event.is_action_released("left_mouse") or event.is_action_pressed("left_mouse")
	
	if card_ui.targets.size() > 0 and card_ui.target_is_fusion_area() and confirm:
		transition_requested.emit(self, CardState.State.FUSING)
		return

	if is_targeted and mouse_motion and card_ui.targets.size() > 0 and not card_ui.target_is_fusion_area():
		transition_requested.emit(self, CardState.State.AIMING)
		return

	if mouse_motion:
		card_ui.global_position = card_ui.get_global_mouse_position() - card_ui.pivot_offset
	
	if cancel:
		transition_requested.emit(self, CardState.State.BASE)
	elif minimum_drag_time_elapsed and confirm:
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, CardState.State.RELEASED)

func exit() -> void:
	Events.card_dragging_ended.emit(card_ui)
