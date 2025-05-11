extends Control

"""
This script is for a UI element that uses the signals put out by the SystemMonitor singleton
to display some debug information such as fps and other metrics.
"""

@onready var fps_label = $FPSLabel
@onready var memory_label = $MemoryLabel
@onready var objects_label = $ObjectsLabel
@onready var render_label = $RenderLabel

var system_info: Node

func _ready() -> void:
	system_info = SystemMonitor # use our singleton
	system_info.connect("fps_updated", Callable(self, "_on_fps_updated"))
	system_info.connect("memory_updated", Callable(self, "_on_memory_updated"))
	system_info.connect("object_counts_updated", Callable(self, "_on_object_counts_updated"))
	system_info.connect("render_stats_updated", Callable(self, "_on_render_stats_updated"))
	system_info.connect("toggle_collecting", Callable(self, "_on_collecting_toggle"))
	
	var labels = [fps_label, memory_label, objects_label, render_label]
	for l in labels:
		update_label_color(l)
		update_label_font(l)

func update_label_color(label: Label) -> void:
	label.add_theme_color_override("font_color", ColorManager.get_secondary())

func update_label_font(label: Label) -> void:
	var font = FontManager.primary_font
	label.add_theme_font_override("font", font)
	label.add_theme_font_size_override("font_size", 16)
	
func _on_fps_updated(current: int) -> void:
	# change the color based on performance
	var color = Color.GREEN
	if current < 30:
		color = Color.RED
	elif current < 55:
		color = Color.YELLOW
		
	fps_label.text = "FPS: %d" % current
	fps_label.add_theme_color_override("font_color", color)

func _on_memory_updated(static_mem: float) -> void:
	memory_label.text = "Memory: %.1f MB" % static_mem

func _on_object_counts_updated(total_objects: int, total_nodes: int) -> void:
	objects_label.text = "Objects: %d (Nodes: %d)" % [total_objects, total_nodes]

func _on_render_stats_updated(draw_calls: int) -> void:
	render_label.text = "Draw Calls: %d" % draw_calls

func _on_collecting_toggle(status: bool) -> void:
	visible = status