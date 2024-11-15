class_name NPC extends CharacterBody2D

const WALK_SPEED = -300.0
enum State {
	WALKING,
	STOPPED,
}

var _state
var type
var bribe = 0
var aggression = 0
var refused = 0
var refusal_max = 0
var dialog = []

func _ready():
	pass

func _physics_process(delta: float):
	if _state == State.WALKING:
		move_and_slide()

func set_type(npc):
	print(npc)
	$Sprite.texture = load(npc.icon)
	type = npc.name
	bribe = npc.bribe
	aggression = npc.aggression
	refusal_max = npc.refusal_max
	dialog = npc.dialogue

func start_move():
	velocity.x = WALK_SPEED
	_state = State.WALKING
	#$DialoguePlayer.dialogue_file = ("res://resources/dialogue/dialogue.cfg")
	#$DialoguePlayer.npc_type = npc_type
	#$Timer.start()

func start_exit(enter):
	$Dialogue.hide()
	_state = State.WALKING
	if !enter:
		velocity.x = -WALK_SPEED

func _on_timer_timeout() -> void:
	print(position)
	_state = State.STOPPED
	$Dialogue.show_dialogue(type, dialog, bribe)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func refused_entry():
	# skip refusals
	refused += 1 #* aggression
	$Dialogue.next_dialogue(1)
