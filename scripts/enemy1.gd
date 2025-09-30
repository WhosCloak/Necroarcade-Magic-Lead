extends CharacterBody2D

#Variables
@export var speed = 50
@export var player: Node2D = null
var grunt = preload("res://audios/general sounds/zombie_grunt.mp3")

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var zombie_audio: AudioStreamPlayer2D = $ZombieGrunt
@onready var sprite:AnimatedSprite2D = $AnimatedSprite2D
var flip_threshold := 1.0


func _ready() -> void:
	# Find the player by group
	player = get_tree().get_first_node_in_group("player")
	$NavigationAgent2D.target_position = player.global_position


func model_facing() -> void:
	if sprite == null:
		return
	if abs(velocity.x) > flip_threshold:
		sprite.flip_h = velocity.x < 0.0
		
		
	
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
	model_facing()


func _on_area_2d_body_entered(body: Node2D) -> void:
	$AnimatedSprite2D.play("attack")
	await $AnimatedSprite2D.animation_finished

	if is_instance_valid(body) and body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(1)
		die()


#Death / Scoring
func die() -> void:
	if player and player.has_method("add_score"):
		player.add_score()
	call_deferred("queue_free")


func _on_grunt_timer_timeout() -> void:
	zombie_audio.play()


func _on_repath_timer_timeout() -> void:
	pass # Replace with function body.
