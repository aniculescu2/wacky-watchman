extends Node2D

@export var npc_scene: PackedScene

static var peasant
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_game():
	show()
	next_npc(false)

func next_npc(enter):
	if peasant:
		peasant.start_exit(enter)
	peasant = npc_scene.instantiate()
	peasant.get_node("Dialogue").dialogue_finished.connect(_on_dialogue_finished)
	add_child(peasant)
	peasant.start_move()

func _on_dialogue_finished() -> void:
	$Player/Choices.show()

func _on_yes_button_button_up() -> void:
	next_npc(true)

func _on_no_button_button_up() -> void:
	next_npc(false)
