class_name LogCmdSpellCreateUnit
extends LogCmdSpellBase

func _init(param_dictionary).(param_dictionary):
	image_path = "res://art/spells/creation.png"
	name = "Create Unit"
	mana_cost = 5
	action_cost = 1
	cooldown = 1
	selection_limit = 1
	# Temporal solution?
	selected_tiles = param_dictionary["tiles"] if param_dictionary.has("tiles") else []

func verify():
	if selected_tiles.empty():
		return ErrorInfo.new(ErrorInfo.invalid.no_spell_target)
	for tile in selected_tiles:
		if not is_valid_selection(tile):
			return ErrorInfo.new(ErrorInfo.invalid.invalid_spell_target)
	return .verify()

func pack_command():
	var pack = {}
	pack["command_name"] = "LogCmdSpellCreateUnit"
	pack["caller"] = caller
	pack["tiles"] = MatchLogic.pack_object_ids(selected_tiles)
	return pack

static func unpack_command(Data, pack):
	var tiles = MatchLogic.unpack_object_ids(Data, pack["tiles"])
	pack["tiles"] = tiles
	return pack

# ---------------------------------------------------- #


func is_valid_selection(object):
	if object.get_hex().get_unit() != null:
		return false
	if not object.passable:
		return false
	if object.lethal:
		return false
	return true

var selected_tiles = []
func new_selected(object:ObjectLogicBase):
	if not is_valid_selection(object):
		return

	if selected_tiles.has(object):
		object.set_select(false)
		selected_tiles.erase(object)
	else:
		object.set_select(true)
		selected_tiles.append(object)
		
	if selected_tiles.size() > selection_limit:
		var tile = selected_tiles.pop_front()
		tile.set_select(false)

func clear_selection():
	for tile in selected_tiles:
		tile.set_select(false)

func cast():
	var error = verify()
	if error.is_valid():
		caller = Data.MatchData.get_turn_owner()
		Terminal.add_log(Debug.INFO, Debug.MATCH, "%s casted." % name)
		Data.CommandData.add_existing_command(self)
	return error

func execute():
	var resource_name = Resources.Ball
	for tile in selected_tiles:
		var xy_coords = HexMath.qr_to_xy(tile.get_hex().get_coords())
		var new_unit = Data.ObjectData.create_new_object(resource_name, xy_coords, caller)
		EffectTiredClass.new(caller, new_unit, 1).start_effect()
	.execute()
	set_state(states.done)
