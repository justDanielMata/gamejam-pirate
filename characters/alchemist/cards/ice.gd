extends Card

func apply_effects(targets):
	var vulnerable_effect = VulnerableEffect.new()
	var damage_effect := DamageEffect.new()
	damage_effect.amount = 2
	damage_effect.execute(targets)
	vulnerable_effect.execute(targets)
