extends RefCounted
class_name CommandSet

"""
parent command set. used for modularity in the terminal.
use add_command in init to define then can be passed to the terminal.
"""

var _commands: Dictionary = {}

# adds a new command to this command set
func add_command(name: String, callback: Callable, description: String = "", usage: String = "") -> void:
	_commands[name] = {
		"callback": callback,
		"description": description,
		"usage": usage if not usage.is_empty() else name
	}

func get_commands() -> Dictionary:
	return _commands
	
func get_command(name: String) -> Dictionary:
	if has_command(name):
		return _commands[name]
	return {}

func remove_command(name: String) -> void:
	if has_command(name):
		_commands.erase(name)

func has_command(name: String) -> bool:
	return _commands.has(name)
