extends Node

@onready var tester = PerformanceTester.new()

func _ready():
	add_child(tester)
	#test_example()
	
func test_example():
	var example = func():
		var arr = []
		for i in range(1000):
			arr.append(randi_range(0, 1000))
			#arr.append(i)
		arr.sort()
	
	tester.benchmark("test-example", example)
