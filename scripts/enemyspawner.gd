extends Node2D

# Load enemy scenes
var enemy_scene_1 = preload("res://scenes/enemy1.tscn")
var enemy_scene_2 = preload("res://scenes/enemy2.tscn")
var enemy_scene_3 = preload("res://scenes/enemy3.tscn")

var spawn_interval := 1.0
var timer := 0.0
var spawn_point: Marker2D

func _ready():
	spawn_point = $Marker2D
	randomize()

func _process(delta):
	timer += delta
	if timer >= spawn_interval:
		timer = 0
		spawn_enemy()

func spawn_enemy():
	if not spawn_point:
		return

	# Choose a random enemy scene
	var enemy_scenes = [enemy_scene_1, enemy_scene_2, enemy_scene_3]
	var enemy_scene = enemy_scenes[randi() % enemy_scenes.size()]

	var enemy = enemy_scene.instantiate()
	enemy.global_position = spawn_point.global_position

	get_tree().current_scene.add_child(enemy)
