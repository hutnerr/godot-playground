extends CanvasLayer

func change_scene(target: String) -> void:
	$AnimationPlayer.play("dissolve")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards("dissolve")

# to use you can set the SceneTransition node to an autoload
# then whenever you want to change your scene, you simply call SceneTransition.change_scene(target)
# it will play the animation set and change it.
# you can extend ths and define many custom animations. 

# you could also make it more dynamic by passing defining enums or something and
# having an additional paremeter, then a switch statement that says which animation to play
