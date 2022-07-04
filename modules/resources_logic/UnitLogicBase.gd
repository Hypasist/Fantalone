class_name UnitLogicBase

var hex = null
var unit_display : UnitDisplayBase = null
var _name_id = null
var _owner_id = null

var _alive = true
var _marked_to_delete = false

func _init(name_id, owner_id):
	_name_id = name_id
	_owner_id = owner_id

func get_name_id():
	return _name_id
func set_owner(owner_id):
	_owner_id = owner_id
func get_owner():
	return _owner_id
func get_hex():
	return hex
func place(hex_):
	hex = hex_
	return self
func is_marked_to_delete():
	return _marked_to_delete
func get_display_scene():
	return unit_display

func move_to_hex(destination_hex):
	if hex: if hex.unitLogic == self: hex.unitLogic = null
	if destination_hex: destination_hex.unitLogic = self
	hex = destination_hex

func die():
	_marked_to_delete = true
	_alive = false

func add_to_display_queue(display_command):
	if unit_display:
		unit_display.queue_command(display_command)

func assign_display_scene(display_scene:UnitDisplayBase):
	display_scene.assign_logic_scene(self)
	unit_display = display_scene

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		# destructor logic
		pass
