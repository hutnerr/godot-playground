extends Node

#TODO
# 1. a packed scene commands so I can just slap in some defined command script or node
# and then use that and it should make this terminal very reusable depending on the 
# game i am writing.
# 2. auto command completion
# 3. command history so I can uparrow and get my latest command 
# 4. tilde to open the console
# 5. once I complete 1, i want to make a default commands resource kinda thing.
# printing, clearing,  exiting, 
# 6. also alises for certian commands like exit and close

var console_scene: PackedScene = preload("res://0-core/dev_console/console_ui.tscn")
var console_ui: Control
var is_visible: bool = false

var commands: Dictionary = {} # registered commands

func _ready() -> void:
	print("Terminal singleton initialized")
	
	console_ui = console_scene.instantiate()
	console_ui.visible = false
	add_child(console_ui)
	
	console_ui.command_entered.connect(_on_command_entered)
	console_ui.typing_in_terminal.connect(_on_typing_in_terminal)

	# add some build in commands
	register_command("help", _cmd_help, "Show available commands")
	register_command("exit", _cmd_exit, "Hide the console")

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
