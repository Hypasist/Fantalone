class_name HexCoords
extends Reference

var q : int = 0
var r : int = 0

func _init(q_:int = 0, r_:int = 0):
	q = q_
	r = r_
	return self

func add(qr):
	q += qr.q
	r += qr.r
	return self
	
func to_str():
	return str("(",q,",",r,")")
