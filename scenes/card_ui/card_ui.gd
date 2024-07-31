class_name CardUI extends Control

@onready var panel: Panel = $Panel
@onready var cost: Label = $cost
@onready var icon: TextureRect = $TextureRect
@onready var card_name: Label = $CardName
@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine
@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var targets: Array[Node] = []
@export var card: Card : set = _set_card
@export var char_stats: CharacterStats  : set = _set_char_stats


var original_index := 0
var parent: Control
var tween: Tween
var playable := true : set = _set_playable
var disabled := false

func play() -> void:
	if not card:
		return
	card.play(targets, char_stats)
	queue_free()

func _set_card(value: Card) -> void:
	if not is_node_ready():
		await ready
	
	card = value
	cost.visible = false
	cost.text = str(card.mana_cost)
	if card.mana_cost > 0:
		cost.visible = true
	icon.texture = card.icon
	card_name.text = str(card.id)


func _ready() -> void:
	Events.card_aim_ended.connect(_on_card_drag_or_aiming_ended)
	Events.card_aim_started.connect(_on_card_drag_or_aiming_started)
	Events.card_dragging_ended.connect(_on_card_drag_or_aiming_ended)
	Events.card_dragging_started.connect(_on_card_drag_or_aiming_started)
	card_state_machine.init(self)
	self.add_to_group('cards')

	
func _set_playable(value: bool) -> void:
	playable = value
	if not playable:
		cost.add_theme_color_override("font_color", Color.RED)
		icon.modulate = Color(1,1,1,0.5)
	else:
		cost.remove_theme_color_override("font_color")
		icon.modulate = Color(1,1,1,1)
		
func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value
	char_stats.stats_changed.connect(_on_char_stats_changed)

func _on_card_drag_or_aiming_started(used_card: CardUI) -> void:
	if used_card == self:
		return
	
	disabled = true

func _on_card_drag_or_aiming_ended(_card: CardUI) -> void:
	disabled = false
	self.playable = char_stats.can_play_card(card)

func _on_char_stats_changed() -> void:
	self.playable = char_stats.can_play_card(card)

func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)

func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)
		
func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()

func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()

func _on_drop_point_detector_area_entered(area):
	if not targets.has(area):
		targets.append(area)
	

func animate_to_position(new_position: Vector2, duration: float) -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", new_position, duration)

func _on_drop_point_detector_area_exited(area):
	targets.erase(area)

func target_is_fusion_area() -> bool:
	return targets.has(get_tree().get_first_node_in_group("ui_layer_group").get_node("%FusionArea"))

func cancel_fusion() -> void:
	card_state_machine.current_state.transition_requested.emit(card_state_machine.current_state, CardState.State.BASE)
	Events.reparent_requested.emit(self, "hand")
