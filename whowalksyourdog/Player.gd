extends KinematicBody2D


signal say_something(command)

onready var Anim = $AdvenSprite
onready var Emote = $Emote

var walk_speed := 80
var run_speed := 150
var gravity := 2500
var jump_speed := 550
var say_time = 0.5

var velocity := Vector2.ZERO


func _process(delta: float) -> void:
	change_animation()


func change_animation():
	# face left or right
	if velocity.x > 0:
		Anim.flip_h = false
	elif velocity.x < 0:
		Anim.flip_h = true
	
	if velocity.y < 0: # negative Y is up
		Anim.play("jump_right")
	elif velocity.y > 0: # falling
		Anim.play("fall_right")
	else:
		if velocity.x != 0:
			Anim.play("walk_right")
		else:
			Anim.play("idle_right")


func _physics_process(delta: float) -> void:
	# reset horizontal velocity
	velocity.x = 0
	
	# reset
	if Input.is_action_pressed("cheat_reset"):
		get_tree().reload_current_scene()

	# set horizontal velocity
	if Input.is_action_pressed("move_right"):
		velocity.x += walk_speed
	if Input.is_action_pressed("move_left"):
		velocity.x -= walk_speed

	# apply gravity
	# player always has downward velocity
	velocity.y += gravity * delta
	
	 # jump will happen on the next frame
	if Input.is_action_just_pressed("move_jump"):
		if is_on_floor():
			velocity.y = -jump_speed # negative Y is up in Godot

	# actually move the player
	velocity = move_and_slide(velocity, Vector2.UP)


func _unhandled_input(event):
	if not Emote.is_visible():
		if event.is_action_pressed("say_go"):
			say("go")
		elif event.is_action_pressed("say_stop"):
			say("stop")


func say(command):
	Emote.play("say_" + command)
	Emote.set_visible(true)
	emit_signal("say_something", command)
	yield(get_tree().create_timer(say_time), "timeout")
	Emote.set_visible(false)
