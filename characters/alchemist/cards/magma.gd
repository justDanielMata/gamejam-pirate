extends Card

func apply_effects(targets):
	var burning_effect = BurningEffect.new()
	var damage_effect := DamageEffect.new()
	damage_effect.amount = 2
	damage_effect.execute(targets)
	burning_effect.execute(targets)
