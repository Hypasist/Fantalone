extends UnitLogicBase

func _init(name_id, owner_id).(name_id, owner_id):
	innate_tag_list.append(TagList.CANNOT_BE_SELECTED)
	innate_tag_list.append(TagList.CANNOT_BE_PUSHED)

func get_power():
	return _power

func get_resource():
	return Resources.Icecube