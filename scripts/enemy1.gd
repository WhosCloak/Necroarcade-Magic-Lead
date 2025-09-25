extends CharacterBody2D

#Variables
@export var speed = 100.0
@export var player: Node2D = null
var grunt = preload("res://audios/general sounds/zombie_grunt.mp3")

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var zombie_audio: AudioStreamPlayer2D = $ZombieGrunt


func _ready() -> void:
	# Find the player by group
	player = get_tree().get_first_node_in_group("player")
	
	if player == null:
		print("player not found")
	else:
		print("player found")

	# Play zombie grunt
	zombie_audio.stream = grunt
	zombie_audio.play()


func makepath():
	await get_tree().physics_frame
	if player:
		nav_agent.target_position = player.global_position

func _physics_process(_delta):
	if player:
		nav_agent.target_position = player.global_position
	if nav_agent.is_navigation_finished():
		return
		
	var current_pos = global_position
	var next_pos = nav_agent.get_next_path_position()
	velocity = current_pos.direction_to(next_pos) * speed
	
	move_and_slide()


#Collision / Combat
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(1)
		die()


#Death / Scoring
func die() -> void:
	if player and player.has_method("add_score"):
		player.add_score()
	call_deferred("queue_free")
