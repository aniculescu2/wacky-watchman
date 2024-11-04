extends CanvasLayer

# Path to the next scene to transition to
#@export_file("*.tscn") var next_scene_path: String
signal covered
signal uncovered
func _ready() -> void:
	# Plays the animation backward to fade in
	$AnimationPlayer.play_backwards("Sweep")
	await $AnimationPlayer.animation_finished
	uncovered.emit()

func _process(delta: float) -> void:
	pass

func transition_to(_next_scene) -> void:
	# Plays the Fade animation and wait until it finishes
	$AnimationPlayer.play("Sweep")
	await $AnimationPlayer.animation_finished
	covered.emit()
	get_tree().change_scene_to_file(_next_scene)
	#$Timer.start()
	#await $Timer.timeout
	#$AnimationPlayer.play_backwards("Sweep")
	#await $AnimationPlayer.animation_finished
	#uncovered.emit()
	# Changes the scene

func cover() -> void:
	$AnimationPlayer.play("Sweep")
	await $AnimationPlayer.animation_finished
	covered.emit()

func uncover() -> void:
	$AnimationPlayer.play_backwards("Sweep")
	await $AnimationPlayer.animation_finished
	uncovered.emit()
