extends RefCounted
class_name CommandHistory

"""
used by terminal
stores recent commands so they can be retrieved and used again quickly
"""

# FIXME bug that can be replicated by repeatedly going up and entering the same command from history
# eveneutally it just wont be the same command when it should be

var history: Array[String] = []
var max_history: int = 50
var current_index: int = -1

# adds a command to history
func add(command: String) -> void:
	# don't add empty commands or duplicates
	if command.strip_edges().is_empty() or (not history.is_empty() and history.back() == command):
		return
		
	history.append(command)
	
	if history.size() > max_history:
		history.pop_front()
	reset_index()

# older commands
func navigate_up() -> String:
	if history.is_empty():
		return ""
	
	if current_index == -1:  # first time pressing up
		current_index = history.size() - 1
	elif current_index > 0:  # can still go up
		current_index -= 1
	
	return history[current_index]

# newer commands
func navigate_down() -> String:
	if history.is_empty() or current_index == -1:
		return ""
	
	current_index += 1
	
	if current_index >= history.size():
		reset_index()
		return ""
	
	return history[current_index]

func clear() -> void:
	history.clear()
	reset_index()

func reset_index() -> void:
	current_index = -1
