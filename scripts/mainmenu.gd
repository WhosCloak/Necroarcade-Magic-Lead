extends Control
	
func _on_button_pressed() -> void: #START
	Fade.transition()
	await Fade.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_button_2_pressed() -> void: #OPTIONS
	get_tree().change_scene_to_file("res://scenes/options.tscn")

func _on_button_3_pressed() -> void: #QUIT
	get_tree().quit()
