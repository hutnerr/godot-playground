class_name StateMachine extends Node

signal stateChanged(old, new)

@export var initialState: State
@onready var states = {} # State.stateName (str) : State

var prevState: State
var currentState: State
var parent: Node # the parent of the state machine


func setup(parent: Node) -> void:
	var childStates = get_children()
	if len(childStates) == 0:
		print("no states as children!")
		return
	
	for state in childStates:
		state.parent = parent
		state.machine = self
		states[state.stateName.to_lower()] = state # used for changing states
	
	changeState(initialState.stateName)


func processInput(event: InputEvent) -> void:
	if not currentState:
		return
	currentState.processInput(event)


func processPhysics(delta: float) -> void:
	if not currentState:
		return
	currentState.processPhysics(delta)


func processFrame(delta: float) -> void:
	if not currentState:
		return
	currentState.processFrame(delta)


func changeState(newStateName: String):
	if newStateName not in states:
		return
	
	var newState = states.get(newStateName.to_lower())
	if !newState or newState == currentState:
		return
	
	if currentState:
		currentState.exit()

	prevState = currentState
	currentState = newState
	
	currentState.enter()
	stateChanged.emit(prevState, newState)
	
	if prevState:
		print("Changed from: ", prevState.stateName, " to ", newStateName)
