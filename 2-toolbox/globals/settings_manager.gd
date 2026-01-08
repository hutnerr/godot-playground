extends Node

signal mainMenuRequested

const SETTINGS_MENU_SCENE = preload("res://2-toolbox/user_interface/simple_settings_menu/SimpleSettingsMenu.tscn")

var settingsMenuInstance: CanvasLayer = null

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Clogger.info("Initialized SettingsManager")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggleMenu()
		get_viewport().set_input_as_handled()

func toggleMenu() -> void:
	if settingsMenuInstance and is_instance_valid(settingsMenuInstance):
		closeMenu()
	else:
		openMenu()

func openMenu() -> void:
	if settingsMenuInstance:
		return
	
	Clogger.info("Opening settings menu...")
	settingsMenuInstance = SETTINGS_MENU_SCENE.instantiate()
	get_tree().root.add_child(settingsMenuInstance)
	
	# Get the Control child and connect its signals
	var menuControl = settingsMenuInstance.get_child(0)
	Clogger.info("Menu control found: " + str(menuControl))
	menuControl.mainMenuButtonRequest.connect(_onMainMenuRequested)
	menuControl.closeRequested.connect(closeMenu)
	Clogger.info("Signals connected")
	
	get_tree().paused = true
	AudioManager.playSFX(menuControl.hoverSFX)
	Clogger.action("Opened Settings")

func closeMenu() -> void:
	if not settingsMenuInstance:
		return
	
	Clogger.info("Closing settings menu...")
	get_tree().paused = false
	settingsMenuInstance.queue_free()
	settingsMenuInstance = null
	AudioManager.playSFX(preload("res://0-assets/sfx/button/pressed.ogg"))
	Clogger.action("Closed Settings")

func _onMainMenuRequested() -> void:
	Clogger.info("Main menu requested from settings")
	closeMenu()
	mainMenuRequested.emit()