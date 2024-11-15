extends Node

var _game_started = 0
@onready var _pause_menu := $CanvasLayer/PauseMenu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("toggle_pause"):
		if _game_started == 1:
			var tree := get_tree()
			tree.paused = not tree.paused
			if tree.paused:
				_pause_menu.open()
			else:
				_pause_menu.close()
			get_tree().root.set_input_as_handled()

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
		await $SceneTransition.uncover
		return new_scene
	return null

func new_game():
	var level = await switch_scene("res://level/level.tscn")
	_game_started = 1
	level.day_ended.connect(_on_day_ended)
	level.start_game()

func _on_day_ended():
	new_game()
