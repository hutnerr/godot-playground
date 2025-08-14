class_name Recipe extends Resource

@export var name: String
@export var ingredients: Array[Item]
@export var quantities: Array[int]
@export var result: Item

func canCraft(inventory: Dictionary) -> bool:
	for i in ingredients.size():
		var item = ingredients[i]
		var needed = quantities[i]
		if inventory.get(item, 0) < needed:
			return false
	return true
