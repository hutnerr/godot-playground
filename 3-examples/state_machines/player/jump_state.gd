extends State

func _ready():
	stateName = "jump"
   
func enter():
	parent.velocity.y = -400.0

func processInput(event: InputEvent):
	if event is InputEventKey and event.is_action_pressed("ui_accept") and parent.is_on_floor():
		machine.changeState("jump")

func processPhysics(delta: float):
	if not parent.is_on_floor():
		parent.velocity += parent.get_gravity() * delta
	
	var direction = Input.get_axis("left", "right")
	if direction:
		parent.velocity.x = direction * 300.0
	else:
		parent.velocity.x = move_toward(parent.velocity.x, 0, 300.0)
	
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if direction != 0:
			machine.changeState("move")
		else:
			machine.changeState("idle")
