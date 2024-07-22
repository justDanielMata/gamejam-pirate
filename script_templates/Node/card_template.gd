# meta-name: Card Logic
# meta-description: What happens when a card is played
extends Card

@export var optional_sound: AudioStream

func apply_effect(targets: Array[Node]) -> void:
	print("Write card effects here")
	print("Targets: %s" % targets)
