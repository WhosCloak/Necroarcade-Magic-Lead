extends CharacterBody2D

#Variables
@export var speed = 100.0
var player: Node2D = null
var grunt = preload("res://audios/general sounds/zombie_grunt.mp3")

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var zombie_audio: AudioStreamPlayer2D = $ZombieGrunt


func _ready() -> void:
	# Find the player by group
	player = get_tree().get_first_node_in_group("player")

	# Play zombie grunt
	zombie_audio.stream = grunt
	zombie_audio.play()

	# Wait until navigation is ready, then set path
	await get_tree().process_frame
	await get_tree().physics_frame
	makepath()


#Movement / Pathfinding
func _physics_process(_delta: float) -> void:
	if not player:
		return

	# Get next path position from NavigationAgent2D
	var next_pos: Vector2 = nav_agent.get_next_path_position()


	# Move toward next path point
	var dir: Vector2 = (next_pos - global_position).normalized()
	velocity = dir * speed
	move_and_slide()


# --- Path Updates ---
func makepath() -> void:
	if player:
		nav_agent.target_position = player.global_position

func _on_timer_timeout() -> void:
	makepath()


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
