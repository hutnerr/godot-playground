class_name State extends Node

var stateName: String = "BASE"

# these 2 are set by the state machine
var parent: Node
var machine: StateMachine

func enter() -> void:
	pass


func exit() -> void:
	pass


# more for event driven button presses and actions
# something like movement, despite being input, might work better
# in the processPhysics
func processInput(event: InputEvent) -> void:
	pass


func processPhysics(delta: float) -> void:
	pass


func processFrame(delta: float) -> void:
	pass
