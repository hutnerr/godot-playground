class_name ButtonSFXComponent extends Node

enum Sfx {
	HOVERED,
	PRESSED,
	DISABLED
}

const SFX := {
	Sfx.HOVERED: preload("res://0-assets/sfx/button/hovered.ogg"),
	Sfx.PRESSED: preload("res://0-assets/sfx/button/pressed.ogg"),
	Sfx.DISABLED: preload("res://0-assets/sfx/button/disabled.wav")
}

var target: Control

func _ready() -> void:
	target = get_parent() as Control
	if not target:
		return

	if SFX[Sfx.HOVERED]:
		target.mouse_entered.connect(_on_hover)

	if target.has_signal("pressed"):
		target.pressed.connect(_on_pressed)
	else:
		target.gui_input.connect(_on_gui_input)

func _on_hover() -> void:
	if target is Button and target.disabled:
		# this is lowkey super annoying so i'm commenting it out
		# if SFX[Sfx.DISABLED]:
		# 	AudioManager.playSFX(SFX[Sfx.DISABLED])
		return

	if SFX[Sfx.HOVERED]:
		AudioManager.playSFX(SFX[Sfx.HOVERED])

func _on_pressed() -> void:
	if target is Button and target.disabled:
		if SFX[Sfx.DISABLED]:
			AudioManager.playSFX(SFX[Sfx.DISABLED])
		return

	if SFX[Sfx.PRESSED]:
		AudioManager.playSFX(SFX[Sfx.PRESSED])

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse := event as InputEventMouseButton
		if mouse.pressed and mouse.button_index == MOUSE_BUTTON_LEFT:
			_on_pressed()
