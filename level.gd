extends Node2D

#@export var npc_scene: PackedScene
var npc_scene

static var _npc = null
var _game_started = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_game():
	#show()
#	Bring in first NPC
	next_npc(false)

func next_npc(enter):
#	If NPC exists already, send it to its direction
	if _npc:
		_npc.start_exit(enter)

#	Make new NPC and move to position
	print("sending npc")
	_npc = preload("res://npc.tscn").instantiate()
	_npc.set_rand_type()
	_npc.get_node("Dialogue").npc_dialogue_finished.connect(_on_npc_dialogue_finished)
	add_child.call_deferred(_npc)
	_npc.show()
	_npc.start_move()

## Show Player choices once NPC dialogue is "done"
func _on_npc_dialogue_finished() -> void:
	$Player/Choices.show()

## Actions to take when "yes" button is pressed
func _on_yes_button_button_up() -> void:
	if $Player/Choices/YesButton.text == "1: Accept Bribe":
		$Player.money += _npc.bribe
		$Player/Choices/YesButton.text = "Yes"
	$Player/Choices.hide()
	next_npc(true)

## Actions to take when "no" button is pressed
func _on_no_button_button_up() -> void:
##	Depending on how much they've been refused, send them off or take specific action
##	Actions: offer bribe, start fight, say something
	if _npc.bribe > 0 and _npc.refused < _npc.refusal_max:
		_npc.refused_entry()
		$Player/Choices/YesButton.text = "1: Accept Bribe"
	else:
		$Player/Choices/YesButton.text = "Yes"
		$Player/Choices.hide()
		next_npc(false)
