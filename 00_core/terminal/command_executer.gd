extends RefCounted
class_name CommandExecuter

"""
used by the terminal
stores the command sets
executes command that are located in a command set
"""

signal command_executed(text: String, is_error: bool)

var command_sets: Array[CommandSet] = []

func register_command_set(command_set: CommandSet) -> void:
	command_sets.append(command_set)

func execute(command_name: String, args: Array) -> void:
	# command sets are modular so iterate over them separately 
	for command_set in command_sets:
		var commands = command_set.get_commands()
		if commands.has(command_name): # searching for command
			var cmd = commands[command_name]
			var result = null
			
			# attempt to execute using the callback
			if cmd.callback.is_valid():
				result = cmd.callback.call(args)
				if result is String and not result.is_empty():
					print(result)
				command_executed.emit(command_name, true)
			else:
				print("Error: Invalid command callback")
				command_executed.emit(command_name, false)
			return
	
	print("Error: Unknown command " + command_name)
	command_executed.emit(command_name, false)
