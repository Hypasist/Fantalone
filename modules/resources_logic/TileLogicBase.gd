class_name TileLogicBase
extends ObjectLogicBase

var lethal = false
var passable = false
var safe2spawn = false

func _init(name_id).(name_id):
	pass

func pack():
	var pack = {}
	pack["unique_id"] = get_name_id()
	pack["resource"] = get_resource()
	pack["hex"] = get_hex().pack()
	return pack
