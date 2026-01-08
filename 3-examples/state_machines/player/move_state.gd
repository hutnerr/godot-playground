extends State

func _ready():
	stateName = "move"

func processPhysics(delta: float):
	if not parent.is_on_floor():
		parent.velocity += parent.get_gravity() * delta
	
	if Input.is_action_just_pressed("ui_accept") and parent.is_on_floor():
		machine.changeState("jump")
	
	var direction = Input.get_axis("left", "right")
	if direction != 0:
		parent.velocity.x = direction * 300.0
	else:
		machine.changeState("idle")
	
	parent.move_and_slide()
