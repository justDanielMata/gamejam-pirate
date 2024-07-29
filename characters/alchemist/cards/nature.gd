extends Card

func apply_effects(targets):
	var stun_effect = StunEffect.new()
	stun_effect.execute(targets)
