extends UnitLogicBase

var _selected = false
var _power = 1

func _init(name_id, owner_id).(name_id, owner_id):
	pass

func set_select(value):
	if value and not _selected:
		unit_display.set_select(true)
		_selected = true
	elif not value and _selected: 
		unit_display.set_select(false)
		_selected = false

func get_power():
	return _power
func is_selected():
	return _selected

