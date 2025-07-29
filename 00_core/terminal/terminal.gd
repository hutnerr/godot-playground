extends Control
class_name DevTerminal

"""
the primary terminal class. 
- has tabbing autocomplete
- shows the possible functions
- shows arguments based on typed in command
- has history and supports up/down arrow searching
"""

# get access to our labels so we can directly mess with them
@onready var input_line: LineEdit = $InputLine
@onready var auto_complete_suggestions: RichTextLabel = $AutoComplete
@onready var command_parameter: RichTextLabel = $CommandParameters

# the modular command suite to use
# should be defined by extending a CommandSet
@export var command_suites: Array[Script] = []

var command_history: CommandHistory
var command_executer: CommandExecuter

func _ready() -> void:
	command_history = CommandHistory.new()
	command_executer = CommandExecuter.new()

	# we always want to add in our built ins/defaults
	command_executer.register_command_set(DefaultCommands.new(self))
	
	# load inspector provided test suite
	if command_suites != null:
		for suite in command_suites:
			var instance = suite.new()
			command_executer.register_command_set(instance)

	input_line.text_submitted.connect(_on_input_line_submitted)
	input_line.text_changed.connect(_on_input_line_text_changed)
	input_line.gui_input.connect(_on_input_line_gui_input)
	input_line.grab_focus()
	
	# we want to show all commands initially
	_update_autocomplete_suggestions("")
	_apply_styling()

# this process function ensures we dont have hanging argument hints showing
# after certain operations
func _process(_delta: float) -> void:
	if !input_line.text.length() > 0:
		command_parameter.text = ""

func _on_input_line_submitted(text: String) -> void:
	if text.strip_edges().is_empty():
		return
	
	print("> " + text)
	
	var parts = text.split(" ", false)
	var command = parts[0].to_lower()
	var args = parts.slice(1) if parts.size() > 1 else []
	
	command_history.add(text)
	command_history.reset_index()
	command_executer.execute(command, args)
	
	input_line.clear()
	_update_autocomplete_suggestions("")

func _on_input_line_text_changed(new_text: String) -> void:
	if new_text.is_empty():
		_update_autocomplete_suggestions("")
		return
	
	var parts = new_text.split(" ", false)
	var command_name = ""
	if parts.size() > 0:
		command_name = parts[0]
	
	_update_autocomplete_suggestions(command_name)
	_update_shown_parameters(command_name)

func _update_shown_parameters(command: String) -> void:
	var cset: CommandSet = null
	# search through our command sets till we find the command
	for command_set in command_executer.command_sets:
		if command_set.has_command(command):
			cset = command_set
			break
	
	# if we found the command set that has our command, get the command
	# and set the usage info (the parameters it takes)
	if cset != null:
		var cmd_info = cset.get_command(command)
		command_parameter.text = cmd_info["usage"]
	else:
		command_parameter.text = ""

func _update_autocomplete_suggestions(prefix: String = "") -> void:
	auto_complete_suggestions.clear()
	
	# get the names of all of our commands
	var command_names = []
	for command_set in command_executer.command_sets:
		command_names.append_array(command_set.get_commands().keys())
	
	command_names.sort()
	
	# filter commands that match the prefix
	var matching_commands = []
	for cmd in command_names:
		if prefix.is_empty() or cmd.begins_with(prefix):
			matching_commands.append(cmd)
	
	# add matching commands to the suggestions
	for cmd in matching_commands:
		auto_complete_suggestions.append_text(cmd + "\n")


func _handle_tab_autocomplete() -> void:
	var current_text = input_line.text
	
	if current_text.is_empty():
		return
	
	var matching_commands = []
	
	# search through our command sets, finding ones that we can autocomplete to
	for command_set in command_executer.command_sets:
		var commands = command_set.get_commands().keys()
		for cmd in commands:
			if cmd.begins_with(current_text):
				matching_commands.append(cmd)
	
	# if we've found any, show them
	if matching_commands.size() > 0:
		var suggested_command = matching_commands[-1]
		input_line.text = suggested_command + " "
		_update_shown_parameters(suggested_command)
		input_line.caret_column = input_line.text.length()

func _on_input_line_gui_input(event: InputEvent) -> void:
	# on up arrow, we want to find old commands
	# on down arrow, we want to find "new" commands in history
	# on tab we want to try and autcomplete
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_UP:
				input_line.text = command_history.navigate_up()
				input_line.caret_column = input_line.text.length()
				_on_input_line_text_changed(input_line.text)
				get_viewport().set_input_as_handled()
			KEY_DOWN:
				input_line.text = command_history.navigate_down()
				input_line.caret_column = input_line.text.length()
				_on_input_line_text_changed(input_line.text)
				get_viewport().set_input_as_handled()
			KEY_TAB:
				_handle_tab_autocomplete()
				get_viewport().set_input_as_handled()

func _input(event: InputEvent) -> void:
	# on ` toggle visibility
	if event is InputEventKey and event.pressed and event.keycode == KEY_QUOTELEFT:
		visible = !visible
		if visible:
			input_line.grab_focus()
		get_viewport().set_input_as_handled()

func _apply_styling() -> void:
	# programatically apply styling
	if input_line:
		input_line.add_theme_color_override("font_color", ColorManager.get_secondary())
		input_line.add_theme_color_override("caret_color", ColorManager.get_tertiary())
		auto_complete_suggestions.add_theme_color_override("default_color", ColorManager.get_secondary())
		command_parameter.add_theme_color_override("default_color", ColorManager.get_secondary())
		
		var font = FontManager.primary_font
		if font:
			input_line.add_theme_font_override("font", font)
			auto_complete_suggestions.add_theme_font_override("normal_font", font)
			command_parameter.add_theme_font_override("normal_font", font)
		
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
		input_line.add_theme_stylebox_override("normal", style)
		input_line.add_theme_stylebox_override("focus", style.duplicate())
		input_line.add_theme_stylebox_override("hover", style.duplicate())
		input_line.add_theme_stylebox_override("read_only", style.duplicate())
		
		input_line.add_theme_color_override("selection_color", ColorManager.get_tertiary())
		
		var rtl_style = StyleBoxFlat.new()
		rtl_style.bg_color = ColorManager.get_primary()
		rtl_style.content_margin_left = 10
		rtl_style.content_margin_top = 15
		rtl_style.content_margin_right = 5
		rtl_style.content_margin_bottom = 5
		
		auto_complete_suggestions.add_theme_stylebox_override("normal", rtl_style.duplicate())
		command_parameter.add_theme_stylebox_override("normal", rtl_style.duplicate())
		
		input_line.add_theme_color_override("selection_color", ColorManager.get_tertiary())
		
		self.mouse_filter = Control.MOUSE_FILTER_IGNORE # clicks pass through to children
