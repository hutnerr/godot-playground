extends Node

class_name font_themer

@onready var primary_font = _setup_primary_font()

func _setup_primary_font() -> SystemFont:
	var font = SystemFont.new()
	font.font_names = ["JetBrains Mono", "monospace"]
	return font
