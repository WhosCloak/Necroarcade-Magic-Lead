extends CharacterBody2D

#Variables
var speed := 50
var player: Node2D = null
@export var max_health := 3
var health := max_health
var is_dead := false

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var knight_grunt: AudioStreamPlayer = $KnightGrunt


var flip_threshold := 1.0
var path_recalc_timer := 0.0
var path_recalc_interval := 0.5 # Recalculate path every 0.2 seconds


func _ready() -> void:
	# Find the player by group
	player = get_tree().get_first_node_in_group("player")
	
	# Important: Wait for navigation to be ready
	call_deferred("setup_navigation")


func setup_navigation() -> void:
	# Wait for the first physics frame to ensure NavigationServer is ready
	await get_tree().physics_frame
	
	if player:
		nav_agent.target_position = player.global_position


func model_facing() -> void:
	if sprite == null:
		return
	if abs(velocity.x) > flip_threshold:
		sprite.flip_h = velocity.x < 0.0


func _physics_process(delta):
	if is_dead or not player:
		return
	
	# Update path periodically instead of every frame for performance
	path_recalc_timer += delta
	if path_recalc_timer >= path_recalc_interval:
		path_recalc_timer = 0.0
		nav_agent.target_position = player.global_position
	
	# Check if navigation is finished or path is invalid
	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return
	
	# Get next position in path
	var next_pos = nav_agent.get_next_path_position()
	var current_pos = global_position
	
	# Calculate direction and velocity
	var direction = current_pos.direction_to(next_pos)
	velocity = direction * speed
	
	# Apply movement and handle collisions
	move_and_slide()
	
	# If we hit a wall, recalculate path immediately
	if get_slide_collision_count() > 0 && path_recalc_timer == 0:
		nav_agent.target_position = player.global_position
	
	model_facing()


func _on_area_2d_body_entered(body: Node2D) -> void:
	$AnimatedSprite2D.play("attack")
	knight_grunt.play()
	await $AnimatedSprite2D.animation_finished

	if is_instance_valid(body) and body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(1)
		die()


#Death / Scoring
func take_damage(amount: int) -> void:
	if is_dead:
		return

	health -= amount

	# Optional: Flash animation or sound when hit
	sprite.modulate = Color(1, 0.3, 0.3) # briefly tint red
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1, 1, 1)

	if health <= 0:
		die()


func die() -> void:
	if is_dead:
		return
	is_dead = true

	if player and player.has_method("add_score"):
		player.add_score()

	#$AnimatedSprite2D.play("death")
	#await $AnimatedSprite2D.animation_finished

	call_deferred("queue_free")
