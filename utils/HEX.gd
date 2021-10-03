class_name HEX

var coords = HEXCoords.new(0,0)

var neighbours = [null, null, null, null, null, null]

var tile : TileBase = null
var unit : UnitBase = null
#var prop : PropBase = null

func _init(arrayCoords, object = null):
	if arrayCoords is Array: coords.setA(arrayCoords)
	if arrayCoords is HEXCoords: coords.copy(arrayCoords)
	assignObject(object)
	
func assignObject(object):
	if object == null: return
	if object is TileBase: tile = object
	if object is UnitBase: unit = object
	object.assignHEX(self)

func getNeighbour(direction):
	if direction < neighbours.size():
		return neighbours[direction]

func isPassable():
	return tile && tile.passable

func isTaken():
	return unit != null

func getOwner():
	if unit: return unit.ownerId

func isSelected():
	return unit && unit.selected 

func isLethal():
	if tile == null: return true
	else: return tile && tile.lethal