extends TileMap

var cell
var treeCells = PackedVector2Array([Vector2(12,3), Vector2(12,4), 
Vector2(12,5), Vector2(12,6), Vector2(13,3), Vector2(13,4), Vector2(13,5), Vector2(13,6)])
var cellSourceId
var cellAtlasCoords
var newCellAtlasCoords

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hit(collision_position):
	cell = local_to_map(collision_position)
	if treeCells.has(cell):
		for treeCell in treeCells:
			cellSourceId = get_cell_source_id(0, treeCell)
			cellAtlasCoords = get_cell_atlas_coords(0, treeCell)
			newCellAtlasCoords = Vector2i(cellAtlasCoords[0] + 3, cellAtlasCoords[1])
			set_cell(0, treeCell, cellSourceId, newCellAtlasCoords)
