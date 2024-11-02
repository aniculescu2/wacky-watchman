class_name NPC extends CharacterBody2D

const WALK_SPEED = -300.0
enum State {
	WALKING,
	STOPPED,
}

var _state

func _physics_process(delta: float):
	if _state == State.WALKING:
		move_and_slide()

func start_move():
	velocity.x = WALK_SPEED
	_state = State.WALKING
	$Timer.start()

func start_exit(enter):
	$DialoguePlayer.next_dialogue()
	_state = State.WALKING
	if !enter:
		velocity.x = -WALK_SPEED

func _on_timer_timeout() -> void:
	_state = State.STOPPED
	$Dialogue.show_dialogue($DialoguePlayer)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
