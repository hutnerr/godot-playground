extends Node

# this is just an example of how you can make an extremely simple
# state machine using enums as opposed to a more in depth node system

enum EnumState {
	On,
	Off
}

signal stateChanged(old, new)

var currentState
var prevState

func _ready() -> void:
	currentState = EnumState.Off # start in off

func _process(delta: float) -> void:
	match currentState:
		EnumState.On:
			pass # logic for being on
		EnumState.Off:
			pass # logic for being off
		_:
			pass
	
func changeState(newState: EnumState) -> void:
	if currentState == newState:
		return # don't go into the same state we're in
	
	# perform exit logic here
	match currentState:
		pass
	
	prevState = currentState
	currentState = newState 
	
	# perform enter logic here
	match currentState:
		pass
		
	stateChanged.emit(prevState, newState)
