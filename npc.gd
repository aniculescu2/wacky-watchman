class_name NPC extends CharacterBody2D

const WALK_SPEED = -300.0
enum State {
	WALKING,
	STOPPED,
}

var types = ["peasant", "adventurer"]
var npc_type
var _state
var bribe = 0
var refused = 0
var refusal_max = 0
func _physics_process(delta: float):
	if _state == State.WALKING:
		move_and_slide()

func set_type(ind):
	npc_type = types[ind]
	$Sprite.texture = load("res://resources/art/%s.jpg" % npc_type)
	match npc_type:
		"adventurer":
			bribe += 10
			refusal_max = 1

func set_rand_type():
	set_type(randi() % types.size())

func start_move():
	velocity.x = WALK_SPEED
	_state = State.WALKING
	$DialoguePlayer.dialogue_file = ("res://resources/dialogue/%s.json" % npc_type)
	$Timer.start()

func start_exit(enter):
	$DialoguePlayer.dialogue_finished.emit()
	_state = State.WALKING
	if !enter:
		velocity.x = -WALK_SPEED

func _on_timer_timeout() -> void:
	_state = State.STOPPED
	$Dialogue.show_dialogue($DialoguePlayer, npc_type, bribe)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func refused_entry():
	refused += 1
	$Dialogue.next_dialog(refused)
