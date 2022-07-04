class_name TileLogicBase

var hex = null
var tile_display : TileDisplayBase = null
var _name_id = null

var lethal = false
var passable = false
var safe2spawn = false
var _marked_to_delete = false

func _init(name_id):
	_name_id = name_id

func place(hex_):
	hex = hex_
	return self
func is_marked_to_delete():
	return _marked_to_delete
func get_display_scene():
	return tile_display
func get_name_id():
	return _name_id
func get_hex():
	return hex

func assign_display_scene(display_scene:TileDisplayBase):
	display_scene.assign_logic_scene(self)
	tile_display = display_scene

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		# destructor logic
		pass
