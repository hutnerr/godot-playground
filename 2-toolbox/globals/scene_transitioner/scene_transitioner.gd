extends CanvasLayer

signal sceneChanged

enum TransitionType {
	DISSOLVE,
	NONE # none is instant
}

var _isTransitioning := false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Clogger.info("Initialized Scene Transitioner")


func changeScene(target: String, transition: TransitionType = TransitionType.DISSOLVE) -> void:
	# dynamic loading (runtime path)
	# var level_path = "res://scenes/level_%d.tscn" % current_level
	# SceneTransitioner.changeScene(level_path)

	if _isTransitioning:
		Clogger.warn("Transition already in progress, ignoring request")
		return
	
	_isTransitioning = true
	Clogger.info("Started changing scene...")
	
	await _playTransition(transition)
	
	if not ResourceLoader.exists(target):
		Clogger.error("Scene file does not exist: %s" % target)
		_isTransitioning = false
		return
	
	var err := get_tree().change_scene_to_file(target)
	if err != OK:
		Clogger.error("Failed to change scene to: %s (Error code: %d)" % [target, err])
		_isTransitioning = false
		return
	
	await _playTransitionReverse(transition)
	
	sceneChanged.emit()
	Clogger.info("Changed scene to: %s" % target)
	_isTransitioning = false


func changeSceneToPacked(packedScene: PackedScene, transition: TransitionType = TransitionType.DISSOLVE) -> void:
	# quick menu → game transition (preloaded)
	# const GAME_SCENE = preload("res://scenes/game.tscn")
	# SceneTransitioner.changeSceneToPacked(GAME_SCENE)
	
	if _isTransitioning:
		Clogger.warn("Transition already in progress, ignoring request")
		return
	
	_isTransitioning = true
	Clogger.info("Started changing scene (packed)...")
	
	await _playTransition(transition)
	
	var err := get_tree().change_scene_to_packed(packedScene)
	if err != OK:
		Clogger.error("Failed to change to packed scene (Error code: %d)" % err)
		_isTransitioning = false
		return
	
	await _playTransitionReverse(transition)
	
	sceneChanged.emit()
	Clogger.info("Changed to packed scene")
	_isTransitioning = false


func _playTransition(transition: TransitionType) -> void:
	match transition:
		TransitionType.DISSOLVE:
			$AnimationPlayer.play("dissolve")
			await $AnimationPlayer.animation_finished
		TransitionType.NONE:
			pass # none is instant

func _playTransitionReverse(transition: TransitionType) -> void:
	match transition:
		TransitionType.DISSOLVE:
			$AnimationPlayer.play_backwards("dissolve")
			await $AnimationPlayer.animation_finished
		TransitionType.NONE:
			pass # none is instant