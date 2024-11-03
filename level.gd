extends Node2D

@export var npc_scene: PackedScene

static var npc
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_game():
	show()
#	Bring in first NPC
	next_npc(false)

func next_npc(enter):
#	If NPC exists already, send it to its direction
	if npc:
		npc.start_exit(enter)

#	Make new NPC and move to position
	npc = npc_scene.instantiate()
	npc.set_rand_type()
	npc.get_node("Dialogue").npc_dialogue_finished.connect(_on_npc_dialogue_finished)
	add_child(npc)
	npc.start_move()

## Show Player choices once NPC dialogue is "done"
func _on_npc_dialogue_finished() -> void:
	$Player/Choices.show()

## Actions to take when "yes" button is pressed
func _on_yes_button_button_up() -> void:
	if $Player/Choices/YesButton.text == "1: Accept Bribe":
		$Player.money += npc.bribe
		$Player/Choices/YesButton.text = "Yes"
	$Player/Choices.hide()
	next_npc(true)

## Actions to take when "no" button is pressed
func _on_no_button_button_up() -> void:
##	Depending on how much they've been refused, send them off or take specific action
##	Actions: offer bribe, start fight, say something
	if npc.bribe > 0 and npc.refused < npc.refusal_max:
		npc.refused_entry()
		$Player/Choices/YesButton.text = "1: Accept Bribe"
	else:
		$Player/Choices/YesButton.text = "Yes"
		$Player/Choices.hide()
		next_npc(false)
