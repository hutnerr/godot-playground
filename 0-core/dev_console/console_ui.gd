extends Control

@onready var input_field = $InputField

signal command_entered(command: String, args: Array)
signal typing_in_terminal(text: String)

func _ready():
	_apply_styling()
	
	if input_field:
		# connecting these signals already through godot ui 
		#input_field.text_submitted.connect(_on_input_field_text_submitted)
		#input_field.text_changed.connect(_on_input_field_text_changed)
		input_field.caret_blink = true

func _apply_styling() -> void:
	if input_field:
		input_field.add_theme_color_override("font_color", ColorManager.get_secondary())
		input_field.add_theme_color_override("caret_color", ColorManager.get_tertiary())
		
		var font = FontManager.primary_font
		if font:
			input_field.add_theme_font_override("font", font)
		
		# to stlye our input field 
		var style = StyleBoxFlat.new()
		style.bg_color = ColorManager.get_primary()
		
		# add border with secondary color
		style.border_width_bottom = 3
		style.border_width_top = 3
		style.border_width_left = 3
		style.border_width_right = 3
		style.border_color = ColorManager.get_secondary()
		
		# add padding
		style.content_margin_left = 10
		style.content_margin_top = 5
		style.content_margin_right = 5
		style.content_margin_bottom = 5
		
		# apply style to all states to avoid white borders
		input_field.add_theme_stylebox_override("normal", style)
		input_field.add_theme_stylebox_override("focus", style.duplicate())
		input_field.add_theme_stylebox_override("hover", style.duplicate())
		input_field.add_theme_stylebox_override("read_only", style.duplicate())
		
		input_field.add_theme_color_override("selection_color", ColorManager.get_tertiary())
		
		self.mouse_filter = Control.MOUSE_FILTER_IGNORE  # clicks pass through to children
	
	
func _on_input_field_text_submitted(new_text: String) -> void:
	if new_text.strip_edges().is_empty():
		return
		
	print(new_text)
	
	var temp = new_text.split(" ")
	var command = temp[0].to_lower()
	var args = []
	
	# only get args if they exist
	if temp.size() > 1:
		args = temp.slice(1)
	
	command_entered.emit(command, args)
	
	input_field.clear()
	input_field.grab_focus()

func _on_input_field_text_changed(new_text: String) -> void:
	typing_in_terminal.emit(new_text)
