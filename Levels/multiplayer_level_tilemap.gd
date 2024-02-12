extends TileMap

var cell
var allTreeCells = [] # Array of treeCells
#var treeCells = PackedVector2Array() 
var cellSourceId
var cellAtlasCoords
var newCellAtlasCoords
var timer_id_map = {}
var time_left_id_map = []


# Called when the node enters the scene tree for the first time.
func _ready():
	# Add different breakable woods into the big big array.
	add_to_all_tree_cells(6, 12, -30, -29) # Left 
	add_to_all_tree_cells(17, 24, -30, -29) # Right
	add_to_all_tree_cells(13, 16, -37, -36) #top


# Adds a range of cells into allTreeCells.
# xmin, ymin inclusive; xmax, ymax exclusive.
func add_to_all_tree_cells(xmin, xmax, ymin, ymax):
	var treeCells = PackedVector2Array()
	for x in range(xmin, xmax):
		for y in range(ymin, ymax):
			var cellCoord = Vector2(x, y)
			treeCells.append(cellCoord)
	allTreeCells.append(treeCells)
	#timer_id_map[allTreeCells.size()-1] = -1 # Temporary placeholder
	time_left_id_map.append(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for i in range(0,3):
		# Countdown time
		time_left_id_map[i] -= _delta
		# If time < 0 and tilemap skin is correct skin, reset
		if time_left_id_map[i] < 0 && get_cell_atlas_coords(0, allTreeCells[i][0]).x> 9.0:
			for treeCell in allTreeCells[i]:
				set_cell(0, treeCell, cellSourceId, Vector2(3,5))
			pass
	pass

func hit(collision_position):
	cell = local_to_map(collision_position)
	# Go to next image of cell
	for treeCell_id in range(0, allTreeCells.size()):
		var treeCells = allTreeCells[treeCell_id]
		var currAtlas_x
		if allTreeCells[treeCell_id].has(cell):
			for treeCell in treeCells:
				cellSourceId = get_cell_source_id(0, treeCell)
				cellAtlasCoords = get_cell_atlas_coords(0, treeCell)
				newCellAtlasCoords = Vector2i(cellAtlasCoords[0] + 3, cellAtlasCoords[1])
				set_cell(0, treeCell, cellSourceId, newCellAtlasCoords)
				currAtlas_x = newCellAtlasCoords.x
			# If block has disappeared, start timer to make block show up again
			if currAtlas_x > 9.0:
				time_left_id_map[treeCell_id] = 3.0
				#var timer = Timer.new()
				#add_child(timer)
				#timer_id_map[treeCell_id] = timer.get_instance_id()
				#print("timer id: ",  timer.get_instance_id())
				#timer.wait_time = 3.0
				#timer.one_shot = true
				#timer.connect("timeout", _on_timer_timeout)
				#timer.start()


#func _on_timer_timeout():
	## Determine which timer has 0 left.
	#for treeCell_id in timer_id_map:
		#var timer_id = timer_id_map[treeCell_id]
		#if timer_id == -1:
			#return
		#var timer = instance_from_id(timer_id)
		#if timer.get_time_left() == 0:
			#for treeCell in allTreeCells[treeCell_id]:
				#set_cell(0, treeCell, cellSourceId, Vector2(3,5))
			## Delete timer
			#timer.queue_free()
			## Reset map to -1
			#timer_id_map[treeCell_id] = -1
