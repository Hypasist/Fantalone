class_name TileLogicBase

var hex = null
var tileDisplay : TileDisplayBase = null

var lethal = false
var passable = false
var safe2spawn = false

func setup(hex_):
	hex = hex_
	return self

func setup_display(scene:TileDisplayBase):
	tileDisplay = scene.setup(self, hex)