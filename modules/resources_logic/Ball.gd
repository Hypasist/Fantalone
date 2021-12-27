extends UnitLogicBase

var _selected = false
var _tired = false
var _power = 1

func _init(name_id, owner_id).(name_id, owner_id):
	pass

func select():
	if not _selected:
		unitDisplay.select()
		_selected = true
func deselect():
	if _selected:
		unitDisplay.deselect()
		_selected = false
		
func tire():
	if not _tired:
		_tired = true
func untire():
	if _tired:
		_tired = false

func get_power():
	return _power
func is_tired():
	return _tired
func is_selected():
	return _selected

