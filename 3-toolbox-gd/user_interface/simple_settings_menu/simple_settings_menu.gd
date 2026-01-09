extends Control

signal mainMenuButtonRequest
signal closeRequested

@onready var quitButton: Button = $PanelContainer/MarginContainer/MainContainer/QuitButton
@onready var quitButtonSpacer: Control = $PanelContainer/MarginContainer/MainContainer/Spacer4
@onready var closeSettingsButton: Button = $PanelContainer/MarginContainer/MainContainer/CloseButton
@onready var mainMenuButton: Button = $PanelContainer/MarginContainer/MainContainer/MainMenuButton
@onready var mainMenuButtonSpacer: Control = $PanelContainer/MarginContainer/MainContainer/Spacer3
@onready var coveragePanel: Panel = $CoveragePanel

var hoverSFX = preload("res://0-assets/sfx/button/hovered.ogg")
var pressedSFX = preload("res://0-assets/sfx/button/pressed.ogg")

const MAIN_PATH = "res://1-playground_core/Main.tscn"

func _ready() -> void:
	updateButtonVisibility()
	mainMenuButton.pressed.connect(_onMainMenuButtonPressed)
	quitButton.pressed.connect(_onQuitButtonPressed)
	closeSettingsButton.pressed.connect(_onCloseSettingsButtonPressed)
	
func updateButtonVisibility() -> void:
	var isMainMenu = get_tree().current_scene.scene_file_path == MAIN_PATH
	
	mainMenuButton.visible = not isMainMenu
	mainMenuButtonSpacer.visible = not isMainMenu
	quitButton.visible = not isMainMenu
	quitButtonSpacer.visible = not isMainMenu

func _onMainMenuButtonPressed() -> void:
	mainMenuButtonRequest.emit()
	SceneTransitioner.changeScene(MAIN_PATH)
	# AudioManager.playMusic(AudioManager.Music.MENU)

func _onQuitButtonPressed() -> void:
	get_tree().quit()

func _onCloseSettingsButtonPressed() -> void:
	closeRequested.emit()
