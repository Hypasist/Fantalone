class_name UnitLogicBase

var hex = null
var unitDisplay : UnitDisplayBase = null
var _name_id = null

var _alive = true
var _marked_to_delete = false

func _init(name_id):
	_name_id = name_id

func get_name_id():
	return _name_id

func setup(hex_):
	hex = hex_
	return self

func setup_display(scene:UnitDisplayBase):
	unitDisplay = scene.setup(self)

func move_to_hex(destination_hex):
	if hex: if hex.unitLogic == self: hex.unitLogic = null
	if destination_hex: destination_hex.unitLogic = self
	hex = destination_hex

func die():
	_marked_to_delete = true
	_alive = false

func add_to_display_queue(display_command):
	if unitDisplay:
		unitDisplay.queue_command(display_command)
