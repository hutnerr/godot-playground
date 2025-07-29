class_name OnHoverAnimComponent extends Node

# this component will call a tween on hover of its parent
# basically a very simple animation to whatveer it is added to

@export var fromCenter: bool = true # to ensure we scale from the center and not the top left corner
@export var hoverScale : Vector2 = Vector2(1.1, 1.1)
@export var time : float = 0.1
@export var transitionType: Tween.TransitionType

var target: Control
var defaultScale : Vector2

func _ready() -> void:
	target = get_parent()
	target.mouse_entered.connect(onHover)
	target.mouse_exited.connect(offHover)
	call_deferred("setup") # load when the frame is done

func setup() -> void:
	if fromCenter:
		target.pivot_offset = target.size / 2 # middle point of button
	defaultScale = target.scale

func onHover() -> void:
	addTween("scale", hoverScale, time)
	
func offHover() -> void:
	addTween("scale", defaultScale, time)
	
func addTween(property: String, value, seconds: float) -> void:
	if is_inside_tree():
		var tween = get_tree().create_tween()
		tween.tween_property(target, property, value, seconds).set_trans(transitionType)
