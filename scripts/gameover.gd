extends Control

#Dynamic score card
func _ready() -> void:
	$Label2.text = "High Score: %d" % Global.high_score

# Button to restart game
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mainmenu.tscn")

#Press ESC to quit
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
