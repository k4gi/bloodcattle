extends Node2D


onready var Map = $Pathfinding


var path = AStar2D.new()


#copied from scrabble/levels/GeneratedLevel.gd on 2022-06-22
#doesn't look that complicated but my eyes are sliding right off. i don't remember.
func build_paths():
	var valid_tiles = Map.get_used_cells()
	
	var i = 0
	for tile in valid_tiles:
		path.add_point( i, (Map.map_to_world(tile) + Map.get_cell_size()/2) * Map.get_scale() )
		
		if valid_tiles.has( Vector2(tile.x+1, tile.y) ):
			i += 1
			path.add_point( i, (Map.map_to_world(tile) + Vector2(Map.get_cell_size().x, Map.get_cell_size().y/2)) * Map.get_scale() )
		
		if valid_tiles.has( Vector2(tile.x+1, tile.y+1) ):
			i += 1
			path.add_point( i, (Map.map_to_world(tile) + Map.get_cell_size()) * Map.get_scale() )
		
		if valid_tiles.has( Vector2(tile.x, tile.y+1) ):
			i += 1
			path.add_point( i, (Map.map_to_world(tile) + Vector2(Map.get_cell_size().x/2, Map.get_cell_size().y)) * Map.get_scale() )
		
		i += 1
	
	for node_one in path.get_points():
		for node_two in path.get_points():
			if node_one != node_two:
				var x_diff = abs(path.get_point_position(node_one).x - path.get_point_position(node_two).x)
				var y_diff = abs(path.get_point_position(node_one).y - path.get_point_position(node_two).y)
				if x_diff <= Map.get_cell_size().x * Map.get_scale().x /2 and \
					y_diff <= Map.get_cell_size().y * Map.get_scale().y /2:
						path.connect_points(node_one, node_two)
