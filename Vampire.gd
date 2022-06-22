extends AnimatedSprite


onready var pathfinding = get_parent().path
onready var target = get_parent().get_node("Destination")
onready var tween = $Tween


var move_pause = false
var move_speed = 1



func _physics_process(_delta):
	if not tween.is_active() and not move_pause:
		var source = pathfinding.get_closest_point( get_position() )
		var destination = pathfinding.get_closest_point( target.get_position() )
		
		var path = pathfinding.get_point_path(source, destination)
		
		if path.size() > 1:
			var tween_speed = move_speed
			
			tween.interpolate_property(self, "position",
				get_position(), path[1], tween_speed,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
