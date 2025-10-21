extends Node2D

@onready var level_root = $LevelRoot
var current_level: Node = null
var level_reached := 1
@onready var player: CharacterBody2D = $player

#Start with level 1
func _ready() -> void:
	load_level("res://scenes/levels/Level_1.tscn")

func _process(_delta: float) -> void:
	check_next_level()

#Level transition based on score
func check_next_level() -> void:
	if level_reached == 1 and Global.player_score >= 10: #CHANGE AFTER LEVEL 2 IS DONE
		Fade.transition()
		await Fade.on_transition_finished
		player.global_position = Vector2(0,0)
		go_to_level_2()
		level_reached = 2

	if level_reached == 2 and Global.player_score >= 20: #CHANGE AFTER LEVEL 3 IS DONE
		Fade.transition()
		await Fade.on_transition_finished
		player.global_position = Vector2(0,0)
		go_to_level_3()
		level_reached = 3

	if level_reached == 3 and Global.player_score >= 30: #CHANGE TO FINAL ZONE
		Fade.transition()
		await Fade.on_transition_finished
		player.global_position = Vector2(0,0)
		go_to_hell()
		level_reached = 4

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
	load_level("res://scenes/levels/level_2.tscn")

func go_to_level_3() -> void:
	load_level("res://scenes/levels/level_3.tscn")

func go_to_hell() -> void:
	load_level("res://scenes/levels/level_4_hell.tscn")
