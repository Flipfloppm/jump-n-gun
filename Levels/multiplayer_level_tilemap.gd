extends TileMap

var breakable_wood_set = {}
var time_left_set = {}
# Boundary of playing space
const XMIN = 0
const XMAX = 31
const YMAX = -1
const YMIN = -55
const RADIUS = 2
#var cell
#var allTreeCells = [] # Array of treeCells
##var treeCells = PackedVector2Array() 
var cellSourceId
var cellAtlasCoords
var newCellAtlasCoords
#var timer_id_map = {}
#var time_left_id_map = []


# Called when the node enters the scene tree for the first time.
# Add all breakable wood indices into the set.
func _ready():
	# Add left block.
	for x in range(6, 12):
		var cellCoord = Vector2i(x, -30)
		breakable_wood_set[cellCoord] = 1
		time_left_set[cellCoord] = 0
	# Add right block.
	for x in range(17, 24):
		var cellCoord = Vector2i(x, -30)
		breakable_wood_set[cellCoord] = 1
		time_left_set[cellCoord] = 0
	# Add top block.
	for x in range(13, 16):
		var cellCoord = Vector2i(x, -37)
		breakable_wood_set[cellCoord] = 1
		time_left_set[cellCoord] = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for cell in time_left_set:
		time_left_set[cell] -= _delta
		if time_left_set[cell] < 0 && get_cell_atlas_coords(0, cell).x > 9.0:
			cellSourceId = get_cell_source_id(0, cell)
			set_cell(0, cell, cellSourceId, Vector2(3,5))


func hit(collision_position):
	var cell = local_to_map(collision_position)
	# Make sure collision cell is in breakable set.
	if !(breakable_wood_set.has(cell)):
		return
	# Consider an area around initial block of radius r = 3
	var breaking_set = {}
	for x_offset in range(-RADIUS, RADIUS+1):
		for y_offset in range(-RADIUS, RADIUS+1):
			var other_cell = Vector2i(cell.x + x_offset, cell.y + y_offset)
			# If cell not in playable space, stop.
			if other_cell.x < XMIN || other_cell.x > XMAX || other_cell.y < YMIN || other_cell.y > YMAX:
				continue
			# Add cell to breaking set.
			else: 
				breaking_set[other_cell] = 1
	# Break blocks
	for block in breaking_set:
		cellSourceId = get_cell_source_id(0, block)
		cellAtlasCoords = get_cell_atlas_coords(0, block)
		newCellAtlasCoords = Vector2i(cellAtlasCoords[0] + 3, cellAtlasCoords[1])
		set_cell(0, block, cellSourceId, newCellAtlasCoords)
		# If broken, change timer.
		if get_cell_atlas_coords(0, block).x > 9.0:
			time_left_set[block] = 3.0

