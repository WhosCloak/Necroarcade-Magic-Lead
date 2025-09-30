extends Node2D

@onready var level_root = $LevelRoot
var current_level: Node = null
var level_reached := 1

#Start with level 1
func _ready() -> void:
	load_level("res://scenes/levels/Level_1.tscn")

func _process(_delta: float) -> void:
	check_next_level()

#Level transition based on score
func check_next_level() -> void:
	if level_reached == 1 and Global.player_score >= 50:
		Fade.transition()
		await Fade.on_transition_finished
		go_to_level_2()
		level_reached = 2

#Load level to Level Root
func load_level(path: String) -> void:
	if current_level and current_level.is_inside_tree():
		current_level.queue_free()
	var level_scene = load(path)
	if not level_scene:
		return
	current_level = level_scene.instantiate()
	level_root.add_child(current_level)

#Ready level 2
func go_to_level_2() -> void:
	load_level("res://scenes/levels/Level_2.tscn")
