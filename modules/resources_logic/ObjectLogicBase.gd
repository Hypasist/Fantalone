class_name ObjectLogicBase

var hex = null
var display : ObjectDisplayBase = null
var _name_id = null
var _marked_to_delete = false
var _selected = false

func _init(name_id):
	_name_id = name_id

func assign_display_scene(display_scene:ObjectDisplayBase):
	display_scene.assign_logic_scene(self)
	display = display_scene

func place(hex_):
	hex = hex_
	return self
func is_marked_to_delete():
	return _marked_to_delete
func get_display_scene():
	return display
func get_name_id():
	return _name_id
func get_hex():
	return hex

func set_select(value):
	if value and not _selected:
		display.set_select(true)
		_selected = true
	elif not value and _selected: 
		display.set_select(false)
		_selected = false
func is_selected():
	return _selected
