extends Node

@onready var btnContainer: GridContainer = $MarginContainer/BtnGridContainer
@export var sceneToStartWith = null

var playgroundScenes = [
	"res://4-playground_scenes/Random.tscn",
	"res://4-playground_scenes/user_interface/UITestEnviornment.tscn",
	"res://4-playground_scenes/StateMachines.tscn",
	"res://4-playground_scenes/ResourcesTest.tscn",
	"res://4-playground_scenes/simple_components/SimpleComponents.tscn",
]

func _ready() -> void:
	if sceneToStartWith != null:
		var scene = load(sceneToStartWith)
		get_tree().change_scene_to(scene)

	for scenePath in playgroundScenes:
		var btn = Button.new()
		btn.text = scenePath.get_file().get_basename()
		btn.pressed.connect(func (path=scenePath):
			var scene = load(path)
			SceneTransitioner.changeSceneToPacked(scene, SceneTransitioner.TransitionType.NONE)
		)

		btn.add_child(ButtonSFXComponent.new())
		btn.add_child(ControlHoverAnimComponent.new())

		btnContainer.add_child(btn)
