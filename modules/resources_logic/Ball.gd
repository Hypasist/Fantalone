extends UnitLogicBase

var owner_id = null
var selected = false
var tired = false

func _init(owner_id_):
	owner_id = owner_id_
	var info = mod.Database.get_player_info(owner_id)
	add_to_group(info.group_name)
