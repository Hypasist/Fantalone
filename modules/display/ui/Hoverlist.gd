extends Node

var hoverlist = []

func add_to_hoverlist(object):
	if !hoverlist.has(object):
		hoverlist.append(object)

func remove_from_hoverlist(object):
	if hoverlist.has(object):
		hoverlist.erase(object)

func get_hovered_unit():
	for hovered_object in hoverlist:
		if hovered_object is UnitLogicBase:
			return hovered_object
