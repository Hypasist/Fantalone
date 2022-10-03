extends TileLogicBase

func _init(name_id).(name_id):
	lethal = false
	passable = true
	safe2spawn = true

func get_resource():
	return Resources.Grass
