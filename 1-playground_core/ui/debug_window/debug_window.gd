extends RichTextLabel

func _ready() -> void:
	SystemMonitor.allStatsUpdated.connect(_onAllStatsUpdated)

func _onAllStatsUpdated(stats: Dictionary) -> void:
	var fpsColor := "green"
	if stats.fps < 30:
		fpsColor = "red"
	elif stats.fps < 55:
		fpsColor = "yellow"
	
	text = ""
	text += "[color=%s]FPS: %d[/color]\n" % [fpsColor, int(stats.fps)]
	text += "Memory: %.1f\n" % stats.memoryMB
	text += "Objects: %d\n" % stats.objects
	text += "Nodes: %d" % stats.nodes