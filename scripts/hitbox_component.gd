class_name HitboxComponent
extends Area2D

@export var health_component : HealthComponent
@export var effect_component : EffectComponent

func damage(attack: Attack):
	if health_component:
		health_component.damage(attack)
	if effect_component:
		if attack.attack_effect:
			effect_component.apply_status(attack.attack_damage,attack.attack_effect, attack.effect_potency)
