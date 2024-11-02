extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Choices.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Choices.visible:
		if Input.is_action_pressed("1"):
			$Choices/YesButton.emit_signal("button_up")
		elif Input.is_action_pressed("2"):
			$Choices/NoButton.emit_signal("button_up")

func _on_yes_button_button_up() -> void:
	$Choices.hide()

func _on_no_button_button_up() -> void:
	$Choices.hide()
