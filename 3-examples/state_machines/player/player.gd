class_name StatePlayer extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var stateMachine = $StateMachine

func _ready() -> void:
	stateMachine.setup(self) # pass the parent down
	
func _unhandled_input(event: InputEvent) -> void:
	stateMachine.processInput(event)

func _physics_process(delta: float) -> void:
	stateMachine.processPhysics(delta)
	
func _process(delta: float) -> void:
	stateMachine.processFrame(delta)
