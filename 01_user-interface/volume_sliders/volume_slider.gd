extends HSlider

@export var busName : String # this is case sensitive
var busIndex : int

func _ready() -> void:
	self.busIndex = AudioServer.get_bus_index(busName)
	value_changed.connect(onValueChanged)
	
	# this sets the slide value to the current audio bus volume. 
	value = db_to_linear(AudioServer.get_bus_volume_db(busIndex))
	
# linear to db helps it become more audio friendly
func onValueChanged(value: float) -> void:
	AudioServer.set_bus_volume_db(busIndex, linear_to_db(value))
