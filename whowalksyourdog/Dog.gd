extends KinematicBody2D

# modulate wot i used
# 09fe07

onready var target = get_parent().get_node("Player")
onready var tween = $Tween
onready var Anim = $DogSprite
onready var tile_size = get_parent().get_node("Pathfinding").get_cell_size()


var active = false
var move_speed = 0.2
var jump_speed = 0.04
var fall_speed = 0.02
var is_walking = false


func _process(_delta):
	change_animation()

func _physics_process(_delta):
	if active and not tween.is_active():
		var source = get_parent().npc_path.get_closest_point( get_position() )
		var destination = get_parent().npc_path.get_closest_point( target.get_position() )
		
		var path = get_parent().npc_path.get_point_path(source, destination)
		
		if path.size() > 1:
			var tween_speed
			if path[1].y < get_position().y:
				tween_speed = jump_speed * abs(get_parent().npc_path.get_point_position(source).y - \
					get_parent().npc_path.get_point_position(destination).y) / tile_size.y
			elif path[1].y > get_position().y:
				tween_speed = fall_speed * abs(get_parent().npc_path.get_point_position(source).y - \
					get_parent().npc_path.get_point_position(destination).y) / tile_size.y
			else:
				tween_speed = move_speed
			
			tween.interpolate_property(self, "position",
				get_position(), path[1], tween_speed,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			if get_position().x > path[1].x:
				Anim.flip_h = true
			else:
				Anim.flip_h = false
			is_walking = true
			tween.start()
		else:
			is_walking = false

func change_animation():
	if is_walking:
		Anim.play("walk_right")
	else:
		Anim.play("idle_right")
