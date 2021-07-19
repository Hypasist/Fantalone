class_name HEXCoords

var q : int = 0
var r : int = 0

func _init(_q:int = 0, _r:int = 0):
	q = _q
	r = _r
	return self
	
func setV(_q, _r):
	q = _q
	r = _r
	
func setA(array):
	if array is Array:
		if array[0]: q = array[0]
		if array[1]: r = array[1]

func copy(coords):
	q = coords.q
	r = coords.r

func toStr():
	return str("(",q,",",r,")")