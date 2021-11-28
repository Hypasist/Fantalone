class_name UnitLogicBase

var hex = null
var unitDisplay : UnitDisplayBase = null
var _alive = true

func setup(hex_):
	hex = hex_
	return self

func setup_display(scene:UnitDisplayBase):
	unitDisplay = scene.setup(self)

func move_to_hex(destination_hex):
	if hex: hex.unitLogic = null
	if destination_hex: destination_hex.unitLogic = self
	hex = destination_hex
	
func die():
	if hex: hex.unitLogic = null
	_alive = false
