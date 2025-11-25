extends Node2D

@onready var level_root = $LevelRoot
@onready var player: CharacterBody2D = $player

var current_level: Node = null
var level_reached := 1
var transitioning := false

const LEVEL_1 = preload("res://scenes/levels/level_1.tscn")
const LEVEL_2 = preload("res://scenes/levels/level_2.tscn")
const LEVEL_3 = preload("res://scenes/levels/level_3.tscn")
const LEVEL_HELL = preload("res://scenes/levels/level_4_hell.tscn")

func _ready() -> void:
	load_level(LEVEL_1)
	$HowToPlayPopup.visible = true

func _process(_delta: float) -> void:
	check_next_level()

func check_next_level() -> void:
	if transitioning:
		return
	
	match level_reached:
		1:
			if Global.player_score >= 10:
				await transition_to(LEVEL_2)
				level_reached = 2
		2:
			if Global.player_score >= 20:
				await transition_to(LEVEL_3)
				level_reached = 3
		3:
			if Global.player_score >= 30:
				await transition_to(LEVEL_HELL)
				level_reached = 4

func load_level(scene: PackedScene) -> void:
	if current_level and current_level.is_inside_tree():
		current_level.queue_free()
		await get_tree().process_frame
	current_level = scene.instantiate()
	level_root.add_child(current_level)

func transition_to(scene: PackedScene) -> void:
	transitioning = true
	Fade.transition()
	await Fade.on_transition_finished
	load_level(scene)
	await get_tree().process_frame
	player.global_position = Vector2(0, 0)
	transitioning = false
