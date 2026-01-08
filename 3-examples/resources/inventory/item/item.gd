class_name Item extends Resource

@export var name: String
@export var icon: Texture2D
@export var rarity: Rarity

enum Rarity {
	COMMON,
	UNCOMMON,
	RARE,
	EPIC,
	LEGENDARY
}
