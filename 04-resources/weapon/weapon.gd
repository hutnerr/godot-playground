extends Node2D

@export var weaponRes: WeaponResource
@onready var sprite2D: Sprite2D = $Sprite2D

func _ready() -> void:
	sprite2D.texture = weaponRes.weaponIcon # use the resource to define the icon
	sprite2D.scale = Vector2(5.0, 5.0)
	print("I am a ", weaponRes.weaponName, ". I deal ", str(weaponRes.damage), " damage and I have a Swing Speed of ", str(weaponRes.swingSpeed))
