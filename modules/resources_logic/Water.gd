extends TileLogicBase

func _init(name_id).(name_id):
	lethal = true
	passable = true
	safe2spawn = false

func get_resource():
	return Resources.Water
