class_name HitboxComponent extends Node

@export var healthComponent: HealthComponent

func damage(attack: Attack):
	if healthComponent:
		healthComponent.damage(attack)

# the collision shape object should be put on this after it's been placed in the scene
