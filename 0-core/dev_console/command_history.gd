extends Node

class_name CommandHistory

var history = []
var position = -1 # not in history

func add_to_history(command):
	# dont add empty or duplicates of last
	if command.strip_edges() == "" or (history.size() > 0 and history.back() == command):
		return
	
	history.push_back(command)
	reset_position()
	
func get_previous_command():
	if history.size() == 0:
		return ""
	
	position = max(0, position - 1)
	return history[position]
	
func get_next_command():
	if history.size() == 0:
		return ""
	
	position = min(history.size(), position + 1)
	if position == history.size():
		return ""
	return history[position]
	
func reset_position():
	position = history.size()
