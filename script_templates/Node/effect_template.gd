# meta-name: Effect
# meta-description: create effect to apply for targets 
class_name CoolEffect extends Effect

func execute(targets: Array[Node]) -> void:
	print("Targets: %s" % targets)
