class_name HEX

var coords = HEXCoords.new(0,0)

var neighbours = [null, null, null, null, null, null]

var tile : TileBase = null
var actor : ActorBase = null
#var prop : PropBase = null

func _init(arrayCoords, object = null):
	if arrayCoords is Array: coords.setA(arrayCoords)
	if arrayCoords is HEXCoords: coords.copy(arrayCoords)
	assignObject(object)
	
func assignObject(object):
	if object == null: return
	if object is TileBase: tile = object
	if object is ActorBase: actor = object
	object.assignHEX(self)

func getNeighbour(direction):
	if direction < neighbours.size():
		return neighbours[direction]

func isPassable():
	return tile && tile.passable

func isTaken():
	return actor != null

func getRace():
	if actor: return actor.colour

func isSelected():
	return actor && actor.selected 

func isLethal():
	if tile == null: return true
	else: return tile && tile.lethal