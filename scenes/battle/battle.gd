class_name Battle extends Node2D

@export var char_stats: CharacterStats
@onready var battle_ui: BattleUI = $BattleUI as BattleUI
@onready var player_handler: PlayerHandler = $PlayerHandler as PlayerHandler
@onready var player = $Player
@onready var enemy_handler: EnemyHandler = $EnemyHandler as EnemyHandler

func _ready() -> void:
	var new_stats: CharacterStats = char_stats.create_instance()
	battle_ui.char_stats = new_stats
	player.stats = new_stats
	
	Events.enemy_turn_ended.connect(_on_enemy_turn_ended)
	Events.player_turn_ended.connect(_on_player_turn_ended)
	Events.player_died.connect(_on_player_died)
	
	start_battle(new_stats)

func start_battle(stats: CharacterStats) -> void:
	player_handler.start_battle(stats)
	
func _on_player_turn_ended() -> void:
	enemy_handler.start_turn()

func _on_enemy_turn_ended() -> void:
	player_handler.start_turn()
	enemy_handler.reset_enemy_actions()
	enemy_handler.clear_enemy_statuses()


func _on_enemy_handler_child_order_changed() -> void:
	if enemy_handler.get_child_count() == 0:
		print("Victory!")

func _on_player_died() -> void:
	print("Game Over!")
