class_name HEXGrid

# CONSTs
var GC = GameConstants

# SCRIPTs
const HGAS = preload("res://utils/HEXGridAdvancedScripts.gd")
const HMath = preload("res://utils/HEXCoordsMath.gd")

# VARs
var contents = []
var cellSize : Vector2 = Vector2(0,0)

func _init(_cellSize):
	cellSize = _cellSize

func addHEX(coordsSquare:Vector2, object = null):
	var coordsHEX : HEXCoords = squareToHEX(coordsSquare)
	
	var newHEX = getHEX(coordsHEX)
	if newHEX: # already exists
		newHEX.assignObject(object)
	else: # create new
		newHEX = HEX.new(coordsHEX, object)
		findNeighbours(newHEX)
		contents.append(newHEX)

func findNeighbours(newHEX:HEX):
	for HEX in contents:
		for dir in GC.directions:
			if HMath.verifyDistance(newHEX.coords, HEX.coords, GC.directions[dir]):
				newHEX.neighbours[dir] = HEX
				HEX.neighbours[GC.opp_dir[dir]] = newHEX

func squareToHEX(coordsSquare:Vector2):
	var x:int = int(round(coordsSquare.x))
	var y:int = int(round(coordsSquare.y))
	var q:int = x - (y - (y%2)) / 2
	var r:int = y
	return HEXCoords.new(q, r)
	
func HEXToSquare(coordsHEX:HEXCoords):
	var x = coordsHEX.q + (coordsHEX.r - (coordsHEX.r%2)) / 2
	var y = coordsHEX.r
	return Vector2(x, y)
	
func getHEX(coordsHEX:HEXCoords):
	for hex in contents:
		if HMath.areEqual(hex.coords, coordsHEX):
			return hex
	return null
	
func squareToPosition(coordsSquare):
	if int(round(coordsSquare.y)) % 2:
		return cellSize * (coordsSquare + Vector2(1,0.5))
	else:
		return cellSize * (coordsSquare + Vector2(0.5,0.5))

func doHEXFormALine(HEXList:Array):
	var startingHEX = HGAS.findBottomLeftHEX(HEXList)
	return HGAS.doHEXFormALine(HEXList, startingHEX, [GC.TOP_LEFT, GC.TOP_RIGHT, GC.RIGHT])

func recognizeFormation(HEXList:Array):
	var formationInfo = {}
	var startingHEX = HGAS.findBottomLeftHEX(HEXList)
	return { "doFormALine"	:	