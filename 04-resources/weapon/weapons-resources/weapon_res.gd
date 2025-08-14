class_name WeaponResource extends Resource

@export var weaponName: String = "SETME"

@export_group("Weapon Stats")
@export var damage: int = 10
@export var swingSpeed: float = 1.0
@export var weaponClass: classes

@export_group("Visuals")
@export var weaponIcon: Texture2D
@export var weaponSound: AudioStream

enum classes {
	SWORD,
	AXE,
	SPEAR
}
