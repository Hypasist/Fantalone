class_name TileLogicBase

var hex = null
var tileDisplay : TileDisplayBase = null
var _name_id = null

var lethal = false
var passable = false
var safe2spawn = false

func _init(name_id):
	_name_id = name_id

func setup(hex_):
	hex = hex_
	return self

func setup_display(scene:TileDisplayBase):
	tileDisplay = scene.setup(self, hex)
