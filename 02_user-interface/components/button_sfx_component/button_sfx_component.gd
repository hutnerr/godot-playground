class_name ButtonSFXComponent extends Node

const HOVER_AUDIO: String = "res://99-assets/sfx/04_sack_open_1.wav"
const PRESSED_AUDIO: String = "res://99-assets/sfx/17_orc_atk_sword_1.wav"
const DISABLED_AUDIO: String = "res://99-assets/sfx/02_chest_close_2.wav"

@export var hoverStream: AudioStream = preload(HOVER_AUDIO)
@export var pressedStream: AudioStream = preload(PRESSED_AUDIO)
@export var disabledStream: AudioStream = preload(DISABLED_AUDIO)

var audioPlayer: AudioStreamPlayer
var target: Button

func _ready() -> void:
	audioPlayer = AudioStreamPlayer.new()
	#audioPlayer.bus = "sfx"
	add_child(audioPlayer)
	
	if not hoverStream and not pressedStream:
		return
	
	target = get_parent() as Button
	target.mouse_entered.connect(onHover)
	target.pressed.connect(onPressed)
	
func onHover() -> void:
	if audioPlayer:
		if target.disabled and disabledStream:
			audioPlayer.stream = disabledStream
			audioPlayer.play()
		elif hoverStream:
			audioPlayer.stream = hoverStream
			audioPlayer.play()

func onPressed() -> void:
	if audioPlayer and pressedStream:
		audioPlayer.stream = pressedStream
		audioPlayer.play()
