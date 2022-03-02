extends KinematicBody2D
class_name AStar_Path

onready var astar = AStar2D.new()
var gridMap
var obstructions
var maxWidth
var maxHeight
var path : PoolVector2Array

func _ready():
	pass
	
func _add_points():
	for x in gridMap.size():
		for y in gridMap[x].size():
			astar.add_point(id(Vector2(x,y)),Vector2(x,y),1.0)

func _connect_points():
	for x in gridMap.size():
		for y in gridMap[x].size():
			var pos = Vector2(x,y)
			var neighbours = [Vector2.RIGHT,Vector2.LEFT,Vector2.DOWN,Vector2.UP]
			
			for neighbour in neighbours:
				var next_pos = pos +neighbour
				if next_pos.x >= 0 and next_pos.y >= 0 and next_pos.x <maxWidth and next_pos.y < maxHeight:
					if gridMap[next_pos.x][next_pos.y] != 6 and gridMap[next_pos.x][next_pos.y] != 0:
						if obstructions[next_pos.x][next_pos.y] is int:
							pass
						elif obstructions[next_pos.x][next_pos.y] == null:
							astar.connect_points(id(pos),id(next_pos),false)
						elif obstructions[next_pos.x][next_pos.y].isPassable == true:
							astar.connect_points(id(pos),id(next_pos),false)
							

func _get_path(start,end):
	path = astar.get_point_path(id(start),id(end))
	path.remove(0)
		

func set_grid(newGrid,obstructionGrid,newMaxWidth, newMaxHeight):
	gridMap = newGrid
	maxWidth = newMaxWidth
	maxHeight = newMaxHeight
	obstructions = obstructionGrid
	_add_points()
	_connect_points()

func id(point):
	var a = point.x
	var b = point.y
	return (a+b)*(a+b+1)/2+b
