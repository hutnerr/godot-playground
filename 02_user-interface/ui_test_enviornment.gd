extends Node

@onready var changeSceneButton: Button = $UI/UIBaseMarginContainer/HBoxContainer/VBoxContainer/ChangeScene

func _ready() -> void:
	changeSceneButton.connect("pressed", _onChangeSceneButtonPressed)

func _onChangeSceneButtonPressed() -> void:
	SceneTransition.change_scene("res://99-assets/placeholder-scenes/Random.tscn")
