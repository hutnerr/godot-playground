class_name VolumeSlider extends HSlider

@export_enum("Master", "music", "sfx") var busName: String
var busIndex : int

func _ready() -> void:
	# these hard coded are so we can just ctrl a and add it 
	# without having to touch the inspector
	self.min_value = 0.0
	self.max_value = 1.0
	self.step = 0.001
	
	self.busIndex = AudioServer.get_bus_index(busName)	
	value_changed.connect(onValueChanged)
	
	# this sets the slide value to the current audio bus volume. 
	value = db_to_linear(AudioServer.get_bus_volume_db(busIndex))
	
# linear to db helps it become more audio friendly
func onValueChanged(new_value: float) -> void:
	AudioServer.set_bus_volume_db(busIndex, linear_to_db(new_value))
	# Clogger.debug("Slider %d changed to %f" % [busIndex, new_value])
	
