extends UnitLogicBase

var _owner_id = null
var _selected = false
var _tired = false
var _power = 1

func _init(owner_id):
	_owner_id = owner_id

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
		unitDisplay.select()
		_tired = true
func untire():
	if _tired:
		unitDisplay.deselect()
		_tired = false

func handle_command(command):
	pass
#	match command.command:hex)

func get_owner():
	return _owner_id
func get_power():
	return _power
func is_tired():
	return _tired
func is_selected():
	return _selected

