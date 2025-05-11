extends Node

#class_name SystemMonitor # this is the name of the singleton

"""
This script gets system information and outputs it as signals. Active as a singleton. 
"""

signal fps_updated(current)
signal memory_updated(static_memory)
signal object_counts_updated(total_objects, total_nodes)
signal render_stats_updated(draw_calls)
signal toggle_collecting(status)

var update_interval: float = 0.5
var time_passed: float = 0.0

var fps_current: float = 0
var running: bool = true # init to true

func _process(delta: float) -> void:
	if not running:
		return

	# get fps on every call, get other stats based on interval 
	track_fps()
	
	time_passed += delta
	if time_passed >= update_interval:
		time_passed = 0.0
		update_stats()

func track_fps() -> void:
	fps_current = Engine.get_frames_per_second()
	emit_signal("fps_updated", fps_current)

func update_stats() -> void:
	var static_memory = Performance.get_monitor(Performance.MEMORY_STATIC) / (1024 * 1024)
	emit_signal("memory_updated", static_memory)
	
	var object_count = Performance.get_monitor(Performance.OBJECT_COUNT)
	var node_count = Performance.get_monitor(Performance.OBJECT_NODE_COUNT)
	emit_signal("object_counts_updated", object_count, node_count)
	
	var draw_calls = Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)
	emit_signal("render_stats_updated", draw_calls)

func toggle_collecting_data() -> void:
	running = !running
	toggle_collecting.emit(running)

# used by a command set
func print_fps(_args: Array) -> void:
	print(fps_current)