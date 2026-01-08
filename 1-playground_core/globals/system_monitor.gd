extends Node

signal fpsUpdated(current: float)
signal memoryUpdated(staticMemory: float)
signal objectCountsUpdated(totalObjects: int, totalNodes: int)
signal renderStatsUpdated(drawCalls: int)
signal allStatsUpdated(stats: Dictionary)

var updateInterval: float = 0.5
var _timePassed: float = 0.0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Clogger.info("Initialized Performance Monitor")

func _process(delta: float) -> void:
	_timePassed += delta
	if _timePassed >= updateInterval:
		_timePassed = 0.0
		_updateStats()

func _updateStats() -> void:
	var stats := {
		"fps": Engine.get_frames_per_second(),
		"memoryMB": Performance.get_monitor(Performance.MEMORY_STATIC) / (1024.0 * 1024.0),
		"objects": int(Performance.get_monitor(Performance.OBJECT_COUNT)),
		"nodes": int(Performance.get_monitor(Performance.OBJECT_NODE_COUNT)),
		"drawCalls": int(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)),
		"physicsTimeMS": Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS) * 1000.0,
		"processTimeMS": Performance.get_monitor(Performance.TIME_PROCESS) * 1000.0,
	}
	
	fpsUpdated.emit(stats.fps)
	memoryUpdated.emit(stats.memoryMB)
	objectCountsUpdated.emit(stats.objects, stats.nodes)
	renderStatsUpdated.emit(stats.drawCalls)
	
	allStatsUpdated.emit(stats)

# get without waiting for next update
# may be useful for direct checks
func getSnapshot() -> Dictionary:
	return {
		"fps": Engine.get_frames_per_second(),
		"memoryMB": Performance.get_monitor(Performance.MEMORY_STATIC) / (1024.0 * 1024.0),
		"objects": int(Performance.get_monitor(Performance.OBJECT_COUNT)),
		"nodes": int(Performance.get_monitor(Performance.OBJECT_NODE_COUNT)),
		"drawCalls": int(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)),
		"physicsTimeMS": Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS) * 1000.0,
		"processTimeMS": Performance.get_monitor(Performance.TIME_PROCESS) * 1000.0,
	}