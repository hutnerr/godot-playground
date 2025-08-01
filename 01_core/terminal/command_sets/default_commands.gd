extends CommandSet
class_name DefaultCommands

"""
These are the default commands that are build into the custom terminal.
They should be there regardless of the current primary command suite that is being used
This also provides an example of how to setup a CommandSet to use in the terminal
"""

var terminal: DevTerminal
var output: RichTextLabel

func _init(term: DevTerminal, output: RichTextLabel) -> void:
	terminal = term
	self.output = output
	
	add_command("clear-history", Callable(self, "_clearhistory_command"), "Clear the terminal history", "clear-history")
	add_command("clear", Callable(self, "_clear_command"), "Clear the output", "clear")
	add_command("history", Callable(self, "_history_command"), "Show command history", "history [count]")
	add_command("help", Callable(self, "_help_command"), "Display available commands", "help [command]")
	add_command("exit", Callable(self, "_exit_command"), "Closes the terminal", "exit")
	add_command("close", Callable(self, "_exit_command"), "Closes the terminal", "close")
	add_command("quit-game", Callable(self, "_quit_game_command"), "Quits the game entirely", "quit-game")
	add_command("toggle-debug", Callable(self, "_toggle_debug"), "Toggles the FPS and other info", "toggle-debug")

#func _toggle_border(_args: Array) -> void:
	# toggles the border of the terminal

func _toggle_debug(_args: Array) -> void:
	SystemMonitor.toggle_collecting_data()

func _quit_game_command(_args: Array) -> void:
	terminal.get_tree().quit()
	
func _exit_command(_args: Array) -> void:
	terminal.visible = false
	terminal.get_tree().paused = false

func _clearhistory_command(_args: Array) -> String:
	terminal.command_history.clear()
	return "Command History Cleared"

func _clear_command(_args: Array) -> void:
	output.text = ""

func _history_command(args: Array) -> String:
	var count = 10
	
	# get the passed in argument, clamp it if necessary
	if not args.is_empty() and args[0].is_valid_int():
		count = min(int(args[0]), terminal.command_history.history.size())
	
	var history = terminal.command_history.history
	var result = "\nCommand history:\n"
	
	# show most recent commands first, up to count
	for i in range(min(count, history.size())):
		var index = history.size() - 1 - i
		result += "%d: %s\n" % [i + 1, history[index]]
	
	return result

func _help_command(args: Array) -> String:
	# if no passed in args, we dont have a specific cmd, show all available commands
	if args.is_empty():
		var result = "\nAvailable commands:"
		
		var all_commands = {}
		for command_set in terminal.command_executer.command_sets:
			var commands = command_set.get_commands()
			for cmd_name in commands:
				all_commands[cmd_name] = commands[cmd_name]
		
		# sort alphabetically
		var sorted_names = all_commands.keys()
		sorted_names.sort()
		
		# build the help text
		for cmd_name in sorted_names:
			result += "\n- %s: %s" % [cmd_name, all_commands[cmd_name].description]
		return result
	
	# show help for a specific command
	var cmd_name = args[0].to_lower()
	
	for command_set in terminal.command_executer.command_sets:
		var commands = command_set.get_commands()
		if commands.has(cmd_name):
			var cmd = commands[cmd_name]
			return "\nCommand: %s\nDescription: %s\nUsage: %s" % [
				cmd_name, 
				cmd.description,
				cmd.usage
			]
	
	return "Error: Unknown command '%s'" % cmd_name
