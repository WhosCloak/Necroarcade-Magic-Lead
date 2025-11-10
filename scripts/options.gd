class_name OptionsMenu
extends Control

@onready var exit: Button = $MarginContainer/VBoxContainer/Exit

signal exit_options

func _ready():
	exit.button_down.connect(on_exit_pressed)
	set_process(false)
	
func on_exit_pressed() -> void:
	exit_options.emit()
	set_process(false)
