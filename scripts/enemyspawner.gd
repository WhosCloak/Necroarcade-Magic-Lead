extends Node2D

@export var spawn_interval := 2.0
@export var enemy_scenes: Array[PackedScene]

var timer := 0.0
var spawn_point: Marker2D

func _ready():
	add_to_group("spawners")   # so we can kill all spawners when changing levels
	spawn_point = $Marker2D
	randomize()

func _process(delta):
	timer += delta
	if timer >= spawn_interval:
		timer = 0
		spawn_enemy()
	#print(enemy_scenes)

func spawn_enemy():
	if not spawn_point:
		return
	
	if enemy_scenes.is_empty():
		return

	# Pick a random enemy scene
	var enemy_scene = enemy_scenes[randi() % enemy_scenes.size()]
	var enemy = enemy_scene.instantiate()

	enemy.global_position = spawn_point.global_position

	get_parent().add_child(enemy)
