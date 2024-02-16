extends TileMap

var breakable_wood_set = {}
var wood_time_left_set = {}
const MOSS_TIME = 2.0
var disappearing_moss_set0 = {}
var disappearing_moss_set0_timer = MOSS_TIME
var disappearing_moss_set1 = {}
var disappearing_moss_set1_timer = 0.0

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
	# Add cells to breakable wood set. 
	add_to_breakable_wood(6, 11, -30, -30)
	add_to_breakable_wood(17, 23, -30, -30)
	add_to_breakable_wood(13, 15, -37, -37)
	# Add cells to disappearing moss set.
	add_to_disappearing_moss(5, 11, -55, -55, 0)
	add_to_disappearing_moss(19, 26, -60, -60, 1)
	add_to_disappearing_moss(9, 16, -66, -66, 0)
	add_to_disappearing_moss(1, 7, -74, -74, 1)
	add_to_disappearing_moss(16, 21, -77, -77, 0)


# Helper function to add cells to disappearing moss set.
func add_to_disappearing_moss(xmin, xmax, ymin, ymax, set_num):
	if set_num == 0:
		for x in range(xmin, xmax + 1):
			for y in range(ymin, ymax + 1):
				var cellCoord = Vector2i(x, y)
				disappearing_moss_set0[cellCoord] = 0
	elif set_num == 1:
		for x in range(xmin, xmax + 1):
			for y in range(ymin, ymax + 1):
				var cellCoord = Vector2i(x, y)
				disappearing_moss_set1[cellCoord] = 1


# Helper function to add cells to breakable wood set.
func add_to_breakable_wood(xmin, xmax, ymin, ymax):
	for x in range(xmin, xmax + 1):
		for y in range(ymin, ymax + 1):
			var cellCoord = Vector2i(x, y)
			breakable_wood_set[cellCoord] = 1
			wood_time_left_set[cellCoord] = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Deal with breakable and respawning wood.
	for cell in wood_time_left_set:
		wood_time_left_set[cell] -= _delta
		if wood_time_left_set[cell] < 0 && get_cell_atlas_coords(0, cell).x > 9.0:
			cellSourceId = get_cell_source_id(0, cell)
			set_cell(0, cell, cellSourceId, Vector2(3,5))
	# Deal with disappearing moss.
	disappearing_moss_set0_timer -= _delta
	disappearing_moss_set1_timer -= _delta
	if disappearing_moss_set0_timer <= 0:
		for cell in disappearing_moss_set0:
			cellSourceId = get_cell_source_id(0, cell)
			set_cell(0, cell, cellSourceId, Vector2(abs(get_cell_atlas_coords(0, cell).x - 1),0))
			disappearing_moss_set0_timer = MOSS_TIME
	if disappearing_moss_set1_timer <= 0:
		for cell in disappearing_moss_set1:
			cellSourceId = get_cell_source_id(0, cell)
			set_cell(0, cell, cellSourceId, Vector2(abs(get_cell_atlas_coords(0, cell).x - 1),0))
			disappearing_moss_set1_timer = MOSS_TIME
		


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
			wood_time_left_set[block] = 3.0

