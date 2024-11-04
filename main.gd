extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func switch_scene(scene_path: String,level=-1) -> Node:
	var current_scenes = $SceneContainer.get_children()
	var scene_count: int = current_scenes.size()

	if (scene_count > 0):
		$SceneTransition.cover()

		await $SceneTransition.covered

		for child in current_scenes:
			$SceneContainer.remove_child(child)
			child.queue_free()

		var new_scene = load(scene_path).instantiate()
		$SceneContainer.add_child(new_scene)

		await get_tree().create_timer(0.4).timeout

		$SceneTransition.uncover()
		return new_scene
	return null

func new_game():
	var level = await switch_scene("res://level.tscn")
	await $SceneTransition.uncover
	level.start_game()
