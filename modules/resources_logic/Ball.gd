extends UnitLogicBase

func _init(name_id, owner_id).(name_id, owner_id):
	tag_list.append(TagList.SCORE_UNIT)

func get_power():
	return _power

func get_resource():
	return Resources.Ball
