extends Node

"""
This is the code for the main scene. Ideally shouldn't have much, should be more of a container.
"""

@onready var tester = PerformanceTester.new()

func _ready():
	add_child(tester)
	
func test_example():
	# dont call this from ready cause then it will prevent it from loading
	var example = func():
		var arr = []
		for i in range(1000):
			arr.append(randi_range(0, 1000))
		arr.sort()
	tester.benchmark("test-example", example)
