extends Node
class_name PerformanceTester

"""
To use:
extends Node

@onready var tester = PerformanceTester.new()

func _ready():
	add_child(tester)
	test_example()
	
func test_example():
	var example = func():
		var arr = []
		for i in range(1000):
			arr.append(randi_range(0, 1000))
		arr.sort()
	tester.benchmark("test-example", example)
"""

var iterations: int = 1000 # how many times to run each benchmark
var warmup_iterations: int = 100 # how many to run before timing
var print_console: bool = false # if the individual test should print

var current_test_name: String = ""
var test_results: Dictionary = {} # store test results (arr of times) using the current test name
var test_start_time: int = 0

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS # run even when the game is paused

func start_test(test_name: String) -> void:
	current_test_name = test_name
	test_start_time = Time.get_ticks_usec() # gets time in miroseconds

func end_test() -> float:
	var end_test_time = Time.get_ticks_usec()
	var duration: float = (end_test_time - test_start_time) / 1000.0 # convert to miliseconds
	
	if not test_results.has(current_test_name):
		test_results[current_test_name] = []
	
	test_results[current_test_name].append(duration)
	
	if print_console:
		print("Test '%s': %.3f ms" % [current_test_name, duration])

	current_test_name = "" # reset 
	return duration

# runs a function multiple times to measure its performance
# uses default if -1 is passed
func benchmark(test_name: String, test_function: Callable, iterations: int = -1, warmup: int = -1) -> Dictionary:
	var iter_count = iterations if iterations > 0 else self.iterations
	var warmup_count = warmup if warmup > 0 else self.warmup_iterations
	
	print("Starting benchmark '%s'..." % test_name)
	
	if warmup_count > 0:
		print("Warmup phase (%d iterations)..." % warmup_count)
		for i in range(warmup_count):
			test_function.call()
	
	var times = []
	var total_time = 0.0
	
	for i in range(iter_count):
		start_test(test_name)
		test_function.call()
		var duration = end_test()
		times.append(duration)
		total_time += duration
	
	times.sort()
	var result = {
		"test_name": test_name,
		"iterations": iter_count,
		"average_ms": total_time / iter_count,
		"median_ms": times[iter_count / 2],
		"min_ms": times[0],
		"max_ms": times[iter_count - 1],
		"total_ms": total_time
	}
	
	print_benchmark_summary(result)
	print("Completed testing!")
	return result

func print_benchmark_summary(result: Dictionary) -> void:
	print("\nBenchmark Results for '%s':" % result["test_name"])
	print("  Iterations: %d" % result["iterations"])
	print("  Average: %.3f ms" % result["average_ms"])
	print("  Median:  %.3f ms" % result["median_ms"])
	print("  Min:     %.3f ms" % result["min_ms"])
	print("  Max:     %.3f ms" % result["max_ms"])
	print("  Total time:      %.3f ms\n" % result["total_ms"])
