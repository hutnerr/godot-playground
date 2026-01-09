class_name Clogger

enum LogLevel {
	DEBUG,
	INFO,
	WARN,
	ERROR,
	NONE
}

static var disabled: bool = false
static var debugEnabled: bool = true
static var showTimestamps: bool = true
static var minLogLevel: LogLevel = LogLevel.DEBUG

static func _log(tag: String, msg: String, color: String = "", level: LogLevel = LogLevel.INFO):
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

static func log(tag: String, msg: String):
	var formatted_tag := "[%s]" % tag.to_upper()
	_log(formatted_tag, msg, "cyan", LogLevel.INFO)

static func error(msg: String):
	push_error(msg)
	_log("[ERROR]", msg, "red", LogLevel.ERROR)

static func warn(msg: String):
	push_warning(msg)
	_log("[WARN]", msg, "yellow", LogLevel.WARN)

static func debug(msg: String):
	if debugEnabled:
		_log("[DEBUG]", msg, "gray", LogLevel.DEBUG)

static func action(msg: String):
	_log("[ACTION]", msg, "magenta", LogLevel.INFO)

static func info(msg: String):
	_log("[INFO]", msg, "green", LogLevel.INFO)