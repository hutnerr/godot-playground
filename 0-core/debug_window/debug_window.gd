extends Control

@onready var fps_label = $FPSLabel
@onready var memory_label = $MemoryLabel
@onready var objects_label = $ObjectsLabel
@onready var render_label = $RenderLabel
@onready var system_label = $SystemLabel

var system_info: Node

func _ready():
	system_info = SystemInfo # use our singleton
	system_info.connect("fps_updated", Callable(self, "_on_fps_updated"))
	system_info.connect("memory_updated", Callable(self, "_on_memory_updated"))
	system_info.connect("object_counts_updated", Callable(self, "_on_object_counts_updated"))
	system_info.connect("render_stats_updated", Callable(self, "_on_render_stats_updated"))
	#_update_sys_info(system_info.get_system_info())
	
	var labels = [fps_label, memory_label, objects_label, render_label, system_label]
	for l in labels:
		update_label_color(l)
		update_label_font(l)

func update_label_color(label: Label) -> void:
	label.add_theme_color_override("font_color", ColorManager.get_secondary())

func update_label_font(label: Label) -> void:
	var font = FontManager.primary_font
	label.add_theme_font_override("font", font)
	label.add_theme_font_size_override("font_size", 16)

	
func _on_fps_updated(current):
	# change the color based on performance
	var color = Color.GREEN
	if current < 30:
		color = Color.RED
	elif current < 55:
		color = Color.YELLOW
		
	fps_label.text = "FPS: %d" %current
	fps_label.add_theme_color_override("font_color", color)

func _on_memory_updated(static_mem):
	memory_label.text = "Memory: %.1f MB" % static_mem

func _on_object_counts_updated(total_objects, total_nodes):
	objects_label.text = "Objects: %d (Nodes: %d)" % [total_objects, total_nodes]

func _on_render_stats_updated(draw_calls):
	render_label.text = "Draw Calls: %d" % draw_calls

func _update_sys_info(info):
	var text = "System: %s\n" % info["os_name"]
	text += "CPU: %d cores\n" % info["processor_count"]
	text += "GPU: %s\n" % info["video_driver"]
	text += "Godot: %s\n" % info["godot_version"]
	text += "Window: %dx%d" % [info["screen_size"].x, info["screen_size"].y]
	
	system_label.text = text
