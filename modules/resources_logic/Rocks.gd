extends TileLogicBase

func _init(name_id).(name_id):
	lethal = false
	passable = false
	safe2spawn = false

func get_resource():
	return Resources.Rocks
