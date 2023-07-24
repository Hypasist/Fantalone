class_name LogCmdCreateIcecube
extends LogCmdBase

var selected_tiles = null

func _init(param_dictionary).(param_dictionary):
	name = "LogCmdCreateIcecube"
	selected_tiles = param_dictionary["tiles"] if param_dictionary.has("tiles") else []
	action_cost = 0

func verify():
	if selected_tiles.empty():
		return ErrorInfo.new(ErrorInfo.invalid.no_spell_target)
	for tile in selected_tiles:
		if not is_valid_selection(tile):
			return ErrorInfo.new(ErrorInfo.invalid.invalid_spell_target)
	return .verify()

func is_valid_selection(object):
	if object.get_hex().get_unit() != null:
		return false
	if not object.passable:
		return false
	if object.lethal:
		return false
	return true

func execute():
	var resource_name = Resources.Icecube
	for tile in selected_tiles:
		var xy_coords = HexMath.qr_to_xy(tile.get_hex().get_coords())
		var new_unit = Data.ObjectData.create_new_object(resource_name, xy_coords, caller)
		EffectTiredClass.new(caller, new_unit, 1).start_effect()
	.execute()
	set_state(states.done)

func pack_command():
	var pack = {}
	pack["command_name"] = "LogCmdCreateIcecube"
	pack["caller"] = caller
	pack["tiles"] = MatchLogic.pack_object_ids(selected_tiles)
	return pack

static func unpack_command(Data, pack):
	var tiles = MatchLogic.unpack_object_ids(Data, pack["tiles"])
	pack["tiles"] = tiles
	return pack
