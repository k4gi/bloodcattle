extends AnimatedSprite


onready var pathfinding = get_parent().path
onready var target = get_parent().get_node("Destination")
onready var tween = $Tween
onready var starting_point = get_position()


var move_pause = true
var move_speed = 0.2
var move_forward = true


signal destination_reached()


func _physics_process(_delta):
	if not tween.is_active() and not move_pause:
		var source = pathfinding.get_closest_point( get_position() )
		
		var destination
		if move_forward:
			destination = pathfinding.get_closest_point( target.get_position() )
		else:
			destination = pathfinding.get_closest_point( starting_point.get_position() )
			
		
		var path = pathfinding.get_point_path(source, destination)
		
		if path.size() > 1:
			var tween_speed = move_speed
			
			tween.interpolate_property(self, "position",
				get_position(), path[1], tween_speed,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
		else:
			emit_signal("destination_reached")
			move_pause = true
