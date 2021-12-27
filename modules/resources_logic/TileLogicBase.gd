class_name TileLogicBase

var hex = null
var tileDisplay : TileDisplayBase = null
var _name_id = null

var lethal = false
var passable = false
var safe2spawn = false

func _init(name_id):
	_name_id = name_id

func place(hex_):
	hex = hex_
	return self

func get_hex():
	return hex

func assign_display_scene(display_scene:TileDisplayBase):
	display_scene.assign_logic_scene(self)
	tileDisplay = display_scene
