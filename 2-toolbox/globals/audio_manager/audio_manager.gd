extends Node

enum Music {
	MENU,
}

const MUSIC := {
	# Music.MENU: preload("res://0-assets/music/main-menu.wav"),
}

@onready var musicPlayer: AudioStreamPlayer = $MusicPlayer
@onready var SFXPlayer: AudioStreamPlayer = $SFXPlayer

var _musicTween: Tween

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	musicPlayer.finished.connect(onFinished) # by default we want looping music
	# playMusic(Music.MENU)
	Clogger.info("Initialized AudioManager")

func playMusic(track: Music) -> void:
	# HOWTOUSE: AudioManager.playMusic(AudioManager.Music.MENU)
	if musicPlayer.stream == MUSIC[track]:
		return
	musicPlayer.stream = MUSIC[track];
	musicPlayer.play()
	Clogger.info("Playing music with id: [%s]" % track)

func stopMusic() -> void:
	musicPlayer.stop()
	Clogger.info("Stopped the music")

func pauseMusic() -> void:
	musicPlayer.stream_paused = true

func resumeMusic() -> void:
	musicPlayer.stream_paused = false

func fadeInto(track: Music, duration: float = 2.0) -> void:
	# HOWTOUSE: AudioManager.fadeInto(AudioManager.Music.MENU, 2.0)
	if musicPlayer.stream == MUSIC[track]:
		return
	
	# kill any existing fade tween to prevent overlaps
	if _musicTween and _musicTween.is_running():
		_musicTween.kill()
	
	_musicTween = get_tree().create_tween()
	_musicTween.tween_property(musicPlayer, "volume_db", -80.0, duration / 2)
	_musicTween.tween_callback(func(): playMusic(track))
	_musicTween.tween_property(musicPlayer, "volume_db", 0.0, duration / 2)
	Clogger.info("Fading into music with id: [%s] over %f seconds" % [track, duration])

func playSFX(stream: AudioStream) -> void:
	# HOWTOUSE: AudioManager.playSFX(preload("PATH"))
	
	# We create a new one so SFX have their own unique players and don't
	# conflict with each other / overwrite each other
	var p := AudioStreamPlayer.new()
	p.stream = stream
	p.bus = "sfx"
	add_child(p)
	p.play()
	p.finished.connect(p.queue_free)

func onFinished() -> void:
	musicPlayer.play()
	Clogger.info("Looping current music stream")
