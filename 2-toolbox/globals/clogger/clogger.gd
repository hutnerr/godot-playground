extends Node

# Clogger.log("state", what changed state) 	-> [STATE]  Player changed state
# Clogger.error(why it failed)				-> [ERROR]  X went wrong

enum LogLevel {
	DEBUG,
	INFO,
	WARN,
	ERROR,
	NONE
}

var disabled: bool = false
var debugEnabled: bool = true
var showTimestamps: bool = true
var minLogLevel: LogLevel = LogLevel.DEBUG

func _ready():
	info("Initialized Clogger")

func _log(tag: String, msg: String, color: String = "", level: LogLevel = LogLevel.INFO):
	if disabled or level < minLogLevel:
		return
	
	var output: String = ""
	
	if showTimestamps:
		var time := Time.get_time_dict_from_system()
		output = "[%02d:%02d:%02d] " % [time.hour, time.minute, time.second]
	
	if color:
		output += "[color=%s]%-8s[/color] | %s" % [color, tag, msg]
		print_rich(output)
	else:
		output += "%-8s | %s" % [tag, msg]
		print(output)

func log(tag: String, msg: String):
	var formatted_tag := "[%s]" % tag.to_upper()
	_log(formatted_tag, msg, "cyan", LogLevel.INFO)

func error(msg: String):
	push_error(msg)
	_log("[ERROR]", msg, "red", LogLevel.ERROR)

func warn(msg: String):
	push_warning(msg)
	_log("[WARN]", msg, "yellow", LogLevel.WARN)

func debug(msg: String):
	if debugEnabled:
		_log("[DEBUG]", msg, "gray", LogLevel.DEBUG)

func action(msg: String):
	_log("[ACTION]", msg, "magenta", LogLevel.INFO)

func info(msg: String):
	_log("[INFO]", msg, "green", LogLevel.INFO)