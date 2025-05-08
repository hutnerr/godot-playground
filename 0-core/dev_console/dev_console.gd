extends Node

#TODO
# 1. a packed scene commands so I can just slap in some defined command script or node
# and then use that and it should make this terminal very reusable depending on the 
# game i am writing.
# 2. auto command completion
# 5. once I complete 1, i want to make a default commands resource kinda thing.
# clear history, exit, etc
# this entire console is pretty coupled and poorly coded, needs to be redone. 
# abstract portions away into individual pieces. this script itself is doing too much
# take power away from the UI
# this portion shouldnt interact with the UI but output signals or so
# make this not a singleton, just add it to the main scene
# extend this so I can add command buttons as well. ie buttons that can be defined 
# that just take what would be typed in here and then execute it, can use the same command in the backend
# also when autocomplete is being implemented, when the command you want is determined, make it
# so that the args it wants are placed up above the text input or so

var console_scene: PackedScene = preload("res://0-core/dev_console/console_ui.tscn")
var console_ui: Control
var input_field: LineEdit
var is_visible: bool = false
var toggle_key: int = KEY_QUOTELEFT  # this is `

var command_history: CommandHistory = CommandHistory.new()
var commands: Dictionary = {} # registered commands

func _ready() -> void:
	print("Terminal singleton initialized")
	
	console_ui = console_scene.instantiate()
	console_ui.visible = false
	add_child(console_ui)
	input_field = console_ui.get_node("InputField") as LineEdit
	
	console_ui.command_entered.connect(_on_command_entered)
	console_ui.typing_in_terminal.connect(_on_typing_in_terminal)

	# add some build in commands
	register_command("help", _cmd_help, "Show available commands")
	register_command("exit", _cmd_exit, "Hide the console")

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		if event.keycode == toggle_key:
			toggle_visibility()
			get_viewport().set_input_as_handled() # prevent further processing
		elif is_visible:
			if event.keycode == KEY_UP:
				input_field.text = command_history.get_previous_command()
				input_field.caret_column = input_field.text.length()
			elif event.keycode == KEY_DOWN:
				input_field.text = command_history.get_next_command()
				input_field.caret_column = input_field.text.length()

func toggle_visibility() -> void:
	is_visible = !is_visible
	console_ui.visible = is_visible
	
	if is_visible:
		console_ui.input_field.grab_focus()

func _on_command_entered(command: String, args: Array) -> void:
	print("Command received: %s with args: %s" % [command, args])
	if commands.has(command):
		var cmd_info = commands[command]
		
		# execute it
		var result = cmd_info.callback.call(args)
		
		if result is String:
			print_to_console(result)
		print("Success")
	else:
		print_to_console("Unknown command: " + command)

func _on_typing_in_terminal(text: String) -> void:
	# TODO: auto completion
	pass

func register_command(name: String, callback: Callable, description: String = "") -> void:
	commands[name] = {
		"callback": callback,
		"description": description
	}

func print_to_console(text: String) -> void:
	print("CONSOLE: " + text)

# use the descriptions to print to console
func _cmd_help(args: Array) -> String:
	if args.is_empty():
		var help_text = "Available commands:\n"
		for cmd_name in commands:
			var description = commands[cmd_name].description
			help_text += "- %s: %s\n" % [cmd_name, description]
		return help_text
	else:
		var cmd = args[0]
		if commands.has(cmd):
			return "%s: %s" % [cmd, commands[cmd].description]
		else:
			return "Unknown command: " + cmd

func _cmd_exit(_args: Array) -> String:
	toggle_visibility()
	return "Console hidden"
