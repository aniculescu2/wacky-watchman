extends Node2D

static var num_npc = 0
static var num_accepted = 0
static var num_rejected = 0
static var gold_accepted = 0
var MAX_NPC = 10

@onready var npcs := TextDatabase.new()

signal day_ended
signal fight_started

var _npc = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Load NPC data
	npcs.add_mandatory_property("icon", TYPE_STRING)
	npcs.add_mandatory_property("dialogue")
	npcs.add_mandatory_property("refusal_max", TYPE_INT)
	npcs.add_default_property("bribe", 0)
	npcs.add_default_property("aggression", 0)
	npcs.load_from_path("res://resources/npcs.cfg")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_game():
	print("game started")
	num_npc = 0
	num_accepted = 0
	num_rejected = 0
	gold_accepted = 0
	$Player/Choices/YesButton.button_up.connect(_on_yes_button_button_up)
	$Player/Choices/NoButton.button_up.connect(_on_no_button_button_up)
#	Bring in first NPC
	next_npc(false)

func next_npc(enter):
#	If NPC exists already, send it to its direction
	if _npc:
		_npc.start_exit(enter)

	# When enough NPCs processed, end day
	if num_npc >= MAX_NPC:
		end_day()
	else:
		print("bringing next npc")
		# Make new NPC and move to position
		num_npc += 1
		_npc = preload("./npc.tscn").instantiate()
		# Sets npc random type
		_npc.set_type(npcs.get_array()[randi() % npcs.size()])
		#_npc.set_type(npcs.get_array()[2])
		_npc.get_node("Dialogue").npc_dialogue_finished.connect(_on_npc_dialogue_finished)
		add_child(_npc)
		_npc.show()
		_npc.start_move()

## Show Player choices once NPC dialogue is "done"
func _on_npc_dialogue_finished(exit) -> void:
	if exit:
		$Player/Choices/YesButton.text = "1: Yes"
		$Player/Choices.hide()
		num_rejected += 1
		next_npc(false)
	else:
		$Player/Choices.show()

## Actions to take when "yes" button is pressed
func _on_yes_button_button_up() -> void:
	if $Player/Choices/YesButton.text == "1: Accept Bribe":
		$Player.money += _npc.bribe
		gold_accepted += _npc.bribe
		$Player/Choices/YesButton.text = "1: Yes"
	$Player/Choices.hide()
	num_accepted += 1
	next_npc(true)

## Actions to take when "no" button is pressed
func _on_no_button_button_up() -> void:
##	Depending on how much they've been refused, send them off or take specific action
##	Actions: offer bribe, start fight, say something
	_npc.refused_entry()
	$Player/Choices.hide()

	if _npc.refused == _npc.refusal_max:
		# Depending on refusal_max and other stats, NPC tries to persuade, intimidate, or bribe
		if _npc.bribe > 0:
			$Player/Choices/YesButton.text = "1: Accept Bribe"
		else:
			$Player/Choices/YesButton.text = "1: Yes"
			$Player/Choices.hide()
			num_rejected += 1
			next_npc(false)
	elif _npc.refused > _npc.refusal_max:
		print("npc refused")
		$Player/Choices/YesButton.text = "1: Yes"
		$Player/Choices.hide()
		num_rejected += 1
		next_npc(false)

func end_day():
	_npc = null
	$DayResults.show_results(num_accepted, num_rejected, gold_accepted)

func _on_day_results_visibility_changed() -> void:
	if !$DayResults.visible:
		day_ended.emit()
