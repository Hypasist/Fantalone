class_name HexCoords

var q : int = 0
var r : int = 0

func _init(q_:int = 0, r_:int = 0):
	q = q_
	r = r_
	return self

func toStr():
	return str("(",q,",",r,")")