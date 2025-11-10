class_name Mainmenu
extends Control
	
@onready var start: Button = $MarginContainer/HBoxContainer/VBoxContainer/Start
@onready var options: Button = $MarginContainer/HBoxContainer/VBoxContainer/Options
@onready var exit: Button = $MarginContainer/HBoxContainer/VBoxContainer/Exit
@onready var options_menu: OptionsMenu = $options_menu
@onready var margin_container: MarginContainer = $MarginContainer
@onready var start_level = preload("res://scenes/main.tscn")


func _ready():
	handle_signals()
	

func on_start_pressed() -> void: #START
	Fade.transition()
	await Fade.on_transition_finished
	get_tree().change_scene_to_packed(start_level)

func on_options_pressed() -> void: #OPTIONS
	margin_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true

func on_exit_pressed() -> void: #QUIT
	get_tree().quit()
	
	
func on_exit_options_menu() -> void:
	margin_container.visible = true
	options_menu.visible = false


func handle_signals() -> void:
	start.button_down.connect(on_start_pressed)
	options.button_down.connect(on_options_pressed)
	exit.button_down.connect(on_exit_pressed)
	options_menu.exit_options.connect(on_exit_options_menu)
	
