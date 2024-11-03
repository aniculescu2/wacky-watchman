extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Choices.hide()

static var money = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Choices.visible:
		if Input.is_action_just_released("1"):
			$Choices/YesButton.emit_signal("button_up")
		elif Input.is_action_just_released("2"):
			$Choices/NoButton.emit_signal("button_up")
