extends CharacterBody2D

var speed = 100
var bulletspeed = 500
var bullet = load("res://scenes/Laser.tscn")
var lighting := load("res://scenes/lighting.tscn")
var score = Global.player_score
var max_health := 3
var health := max_health
var gun = preload("res://audios/general impact sounds/gun_impact_var2.mp3")
var flip_threshold := 1.0
var offlightingcooldown := true
var speedup := false
var maxbulletcount := 18
var canshoot := true
var magcount := maxbulletcount
var ammocount := 50

@onready var cam := $Camera2D
@onready var muzzle = $Muzzle
@onready var score_label = $CanvasLayer/Score/Label
@onready var sprite:AnimatedSprite2D = $AnimatedSprite2D
@onready var arm_sprite = $ArmSurvivor
@onready var bulletcount: Label = $CanvasLayer/Bulletcount/bulletcount
@onready var hearts := [
	$CanvasLayer/Hearts/Heart1,
	$CanvasLayer/Hearts/Heart2,
	$CanvasLayer/Hearts/Heart3
]


# Variables for arm movement
var amplitude = 0.5  
var speed_osc = 4.5   # Speed of oscillation
var time_passed = 0.0 
var initial_y = 0.0   # Initial y position of ArmSurvivor

func _ready():
	cam.zoom = Vector2(3.5, 3.5)
	update_hearts()
	cam.set_process(true)
	initial_y = arm_sprite.position.y
	arm_sprite.offset = Vector2(9, 20)
	initial_y = arm_sprite.position.y - 12.5

func _physics_process(_delta):
	var input_vector = Input.get_vector("left", "right", "up", "down")
	velocity = input_vector.normalized() * speed
	move_and_slide()
	muzzle.look_at(get_global_mouse_position())
	model_facing()
	_on_power_up()
		
	if Input.is_action_just_pressed("fire") and canshoot and magcount > 0:
		fire()
		$Gun.play()
	if Input.is_action_just_pressed("reload") and magcount > 0:
		
	if Input.is_action_just_pressed("magic") and offlightingcooldown:
		magic()
		$lighting.play()
		offlightingcooldown = false
		$lightingcooldown.start()
	if input_vector:
		$AnimatedSprite2D.play("Walk_armless")
	else:
		$AnimatedSprite2D.play("Idle_armless")
		time_passed += _delta * speed_osc
		var new_y = initial_y + sin(time_passed) * amplitude
		arm_sprite.position.y = new_y
	arm_sprite.look_at(get_global_mouse_position()) #rotate arm to mouse
	arm_sprite.rotation -= PI / 2
	
	
func model_facing() -> void:
	if sprite == null:
		return
	if abs(velocity.x) > flip_threshold:
		sprite.flip_h = velocity.x < 0.0
		
		
		
func fire():
	canshoot = false
	magcount -= 1
	var bullet_instance = bullet.instantiate()
	var fire_pos = muzzle.global_position
	var direction = (get_global_mouse_position() - fire_pos).normalized()
	
	bullet_instance.global_position = fire_pos
	bullet_instance.rotation = direction.angle()
	bullet_instance.linear_velocity = direction * bulletspeed

	get_tree().current_scene.add_child(bullet_instance)
	

func magic():
	var lighting_instance = lighting.instantiate()
	var fire_pos = muzzle.global_position
	var direction = (get_global_mouse_position() - fire_pos).normalized()
	
	lighting_instance.global_position = fire_pos
	lighting_instance.rotation = direction.angle()
	lighting_instance.linear_velocity = direction * bulletspeed

	get_tree().current_scene.add_child(lighting_instance)
	



func add_score(amount: int = 1) -> void:
	score += amount
	Global.player_score = score
	score_label.text = "Score: %d" % score
	if score % 20 == 0:
		heal(max_health)
		$CanvasLayer/Hearts/Label.visible = true
		await get_tree().create_timer(2).timeout
		$CanvasLayer/Hearts/Label.visible = false
		

func take_damage(amount: int):
	health -= amount
	update_hearts()

	if health <= 0:
		if score > Global.high_score:
			Global.high_score = score
		die()
		

func heal(amount: int):
	health = min(health + amount, max_health)
	update_hearts()


func die() -> void:
	call_deferred("_gameover")

func _gameover():
	Fade.transition()
	await Fade.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/gameover.tscn")
	

func update_hearts():
	for i in range(max_health):
		hearts[i].visible = (i < health)


func _on_lightingcooldown_timeout() -> void:
	offlightingcooldown = true
	
func _on_power_up() -> void:
	if speedup == true:
		print("speed up")
		speed = 200
			
