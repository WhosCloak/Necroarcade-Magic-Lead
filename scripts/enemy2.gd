extends CharacterBody2D

#Variables
var speed := 150
var player: Node2D = null
@export var max_health := 1
@export var desired_path_distance: float = 4.0
@export var max_path_distance: float = 10.0
var health := max_health
var is_dead := false

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var crawler_grunt: AudioStreamPlayer = $CrawlerGrunt


var flip_threshold := 1.0
var path_recalc_timer := 0.0
var path_recalc_interval := 0.5 # Recalculate path every 0.2 seconds


func _ready() -> void:
	# Find the player by group
	player = get_tree().get_first_node_in_group("player")
	nav_agent.path_desired_distance = desired_path_distance
	nav_agent.path_max_distance = max_path_distance
	# Important: Wait for navigation to be ready
	call_deferred("setup_navigation")

func model_facing() -> void:
	if sprite == null:
		return
	if abs(velocity.x) > flip_threshold:
		sprite.flip_h = velocity.x < 0.0


func _physics_process(delta):
	if not player: return
	path_recalc_timer += delta

	# Set target and get next path point
	if path_recalc_timer >= path_recalc_interval:
		nav_agent.target_position = player.global_position
		path_recalc_timer = 0.0
	var next_path_point = nav_agent.get_next_path_position()

	# Calculate velocity towards the next point
	var direction = global_position.direction_to(next_path_point)
	velocity = direction * speed
	move_and_slide()

	model_facing()


func _on_area_2d_body_entered(body: Node2D) -> void:
	$AnimatedSprite2D.play("attack")
	crawler_grunt.play()
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
