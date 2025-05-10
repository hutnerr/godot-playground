extends CommandSet

"""
This is an example of how to setup a command set.
"""

func _init() -> void:
	# functions defined in the set
	add_command("example", Callable(self, "_example"), "Example of a command", "example")
	add_command("echo", Callable(self, "_echo"), "Echos what you typed in", "echo [...]")
	add_command("sayhi", Callable(self, "_say_hi"), "Says hi n times", "sayhi [n]")
	
	# functions not defined here
	add_command("printfps", Callable(SystemMonitor, "print_fps"), "Prints the fps to console", "printfps")
	# when doing this the function must take in args as the executer will always pass it
	# if this is undesireable it is recommended to write a wrapper function here parses the args, and then call

# simple example
func _example(_args: Array): # denoting it _args since not using it
	print("this is an example")
	
# example that uses the args
func _echo(args: Array): # denoted as args since we are using it
	var out: String = ""
	for arg in args:
		out += arg + " "
	print(out)

# example that uses specific args
func _say_hi(args: Array):
	var n = 0
	if not args.is_empty() and args[0].is_valid_int():
		n = int(args[0])
		
	for i in range(n):
		print("hi!")
