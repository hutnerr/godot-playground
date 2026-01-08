class_name HealthComponent extends Node2D

# FIXME: This should be way more in depth

@export var MAX_HEALTH: int = 10
var health: int

func _ready() -> void:
	health = MAX_HEALTH

func damage(attack: Attack):
	health -= attack.attack_damage
	
	if health <= 0:
		get_parent().queue_free()
