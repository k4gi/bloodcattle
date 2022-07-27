extends Node2D


const WALK_MARKER = 0
const JUMP_MARKER = 1


onready var Pathfinding = $Pathfinding


var npc_path = AStar2D.new()


func _ready():
	assemble_npc_path()


func assemble_npc_path():
	var i = 0
	for each_tile in Pathfinding.get_used_cells():
		npc_path.add_point( i, Pathfinding.map_to_world(each_tile) + (Pathfinding.get_cell_size()/2) )
		
		for each_node in npc_path.get_points():
			var point_pos = Pathfinding.world_to_map( npc_path.get_point_position(each_node) )
			# adjacent markers
			if (abs(point_pos.x - each_tile.x) == 1 and point_pos.y - each_tile.y == 0) or \
				(point_pos.x - each_tile.x == 0 and abs(point_pos.y - each_tile.y) == 1):
					npc_path.connect_points(each_node, i)
			# jump markers. up or down!
			elif Pathfinding.get_cellv(each_tile) == JUMP_MARKER and point_pos.x == each_tile.x and \
				each_tile.y - point_pos.y <= 5 and each_tile.y - point_pos.y > 0:
					npc_path.connect_points(each_node, i)
		
		i += 1


func _on_Player_say_something(command):
	match command:
		"go":
			$Dog.active = true
		"stop":
			$Dog.active = false
			$Dog.is_walking = false
		
