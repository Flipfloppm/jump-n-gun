extends TileMap

var cell
var treeCells = PackedVector2Array() 
var cellSourceId
var cellAtlasCoords
var newCellAtlasCoords


# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(73, 75):
		for y in range(-13,-1):
			var cellCoord = Vector2(x, y)
			treeCells.append(cellCoord)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func hit(collision_position):
	cell = local_to_map(collision_position)
	if treeCells.has(cell):
		for treeCell in treeCells:
			cellSourceId = get_cell_source_id(0, treeCell)
			cellAtlasCoords = get_cell_atlas_coords(0, treeCell)
			newCellAtlasCoords = Vector2i(cellAtlasCoords[0] + 3, cellAtlasCoords[1])
			set_cell(0, treeCell, cellSourceId, newCellAtlasCoords)
