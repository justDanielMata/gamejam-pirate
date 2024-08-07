class_name Stats extends Resource

signal stats_changed

@export var max_health := 1
@export var art: Texture
@export var moves_per_turn: int : set = set_moves_per_turn
@export var vulnerable := false
@export var burning := false : set = set_burning
@export var stunned := false : set = set_stunned

var health: int : set = set_health
var block: int : set = set_block

func set_stunned(value: bool) -> void:
	stunned = value

func set_burning(value: bool) -> void:
	burning = value

func set_moves_per_turn(value: int) -> void:
	moves_per_turn = value
	stats_changed.emit()

func set_health(value: int) -> void:
	health = clampi(value, 0, max_health)
	stats_changed.emit()	

func set_block(value: int) -> void:
	block = clampi(value, 0, 999)
	stats_changed.emit()

func reset_block() -> void:
	block = 0
	stats_changed.emit()

func take_damage(damage: int) -> void:
	if vulnerable:
		damage += 2
	if damage <= 0:
		return
	var initial_damage = damage
	damage = clampi(damage - block, 0, damage)
	self.block = clampi(block - initial_damage, 0, block)
	self.health -= damage
	
func heal(amount: int) -> void:
	self.health += amount
	
func create_instance() -> Resource:
	var instance: Stats = self.duplicate()
	instance.health = max_health
	instance.block = 0
	return instance


