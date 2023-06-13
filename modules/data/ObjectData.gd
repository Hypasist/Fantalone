class_name ObjectData
extends Node

var Data = null

const DISPLAY_DISABLED = false
const DISPLAY_ENABLED = true
var display_settings = DISPLAY_DISABLED
func set_display_setting(display_mode):
	display_settings = display_mode
func is_display_enabled():
	return display_settings == DISPLAY_ENABLED

var item_counter = {}
func get_unique_name(resource_name):
	if item_counter.has(resource_name):
		item_counter[resource_name] = item_counter[resource_name] + 1
	else:
		item_counter[resource_name] = 0
	return "%s_%03d" % [resource_name, item_counter[resource_name]]
func assimilate_unique_name(unique_id):
	var id_splitted = unique_id.rsplit("_")
	var resource_name = id_splitted[0]
	var counter = id_splitted[-1].to_int()
	if item_counter.has(resource_name):
		item_counter[resource_name] = max(counter, item_counter[resource_name])
	else:
		item_counter[resource_name] = counter
	return unique_id

func create_new_object(resource_name, coords, match_id=null, _arg1=null, _arg2=null):
	var resource = mod.ResourceData.get_resource(resource_name)
	match resource_name:
		Resources.Ball:
			#qr_coords, owner_id
			var hex = mod.HexMath.get_hex_by_xy_coords(hex_dictionary, coords)
			var unique_name = get_unique_name(resource_name)
			var logic_scene = resource.logic_scene.new(unique_name, match_id)
			unit_list.append(logic_scene)
			hex.place_unit(logic_scene)
			if display_settings:
				var display_scene = resource.display_scene.instance()
				display_scene.set_name(unique_name)
				logic_scene.assign_display_scene(display_scene)
				mod.MapView.add_unit_resource(display_scene)
			return logic_scene
		Resources.Water, Resources.Rocks, Resources.Grass:
			#qr_coords
			var hex = mod.HexMath.get_hex_by_xy_coords(hex_dictionary, coords)
			var unique_name = get_unique_name(resource_name)
			var logic_scene = resource.logic_scene.new(unique_name)
			tile_list.append(logic_scene)
			hex.place_tile(logic_scene)
			if display_settings:
				var display_scene = resource.display_scene.instance()
				display_scene.set_name(unique_name)
				logic_scene.assign_display_scene(display_scene)
				mod.MapView.add_tile_resource(display_scene)
			return logic_scene

func copy_object(pack):
	var resource = mod.ResourceData.get_resource(pack["resource"])
	match pack["resource"]:
		Resources.Ball, Resources.Icecube:
			var hex = mod.HexMath.get_hex_by_qr_coords(hex_dictionary, \
						HexCoords.new(pack["hex"]["q"], pack["hex"]["r"]))
			var unique_name = assimilate_unique_name(pack["unique_id"])
			var logic_scene = resource.logic_scene.new(unique_name, pack["match_id"])
			unit_list.append(logic_scene)
			hex.place_unit(logic_scene)
			if display_settings:
				var display_scene = resource.display_scene.instance()
				display_scene.set_name(unique_name)
				logic_scene.assign_display_scene(display_scene)
				mod.MapView.add_unit_resource(display_scene)
		Resources.Water, Resources.Rocks, Resources.Grass:
			var hex = mod.HexMath.get_hex_by_qr_coords(hex_dictionary, \
						HexCoords.new(pack["hex"]["q"], pack["hex"]["r"]))
			var unique_name = assimilate_unique_name(pack["unique_id"])
			var logic_scene = resource.logic_scene.new(unique_name)
			tile_list.append(logic_scene)
			hex.place_tile(logic_scene)
			if display_settings:
				var display_scene = resource.display_scene.instance()
				display_scene.set_name(unique_name)
				logic_scene.assign_display_scene(display_scene)
				mod.MapView.add_tile_resource(display_scene)
		Resources.EffectDead, Resources.EffectFrozen, Resources.EffectTired:
			var caster = mod.MatchData.get_unit_by_name(pack["caster"])
			var target = mod.MatchData.get_unit_by_name(pack["target"])
			var logic_scene = resource.logic_scene.new(caster, target, pack["duration"])
			logic_scene.start_effect()

func remove_all_objects():
	remove_all_units()
	remove_all_tiles()

## HEX

var hex_dictionary = {}
func get_hex_dictionary():
	return hex_dictionary

## UNITS

var unit_list = []

func get_unit_list():
	for unit in unit_list:
		if null == unit:
			Terminal.add_log(Debug.ERROR, Debug.MATCH, "Null in unit list!")
	return unit_list

func remove_all_units():
	for i in range(unit_list.size() - 1, -1, -1):
		remove_unit(unit_list[i], true)

func remove_unit_list(removal_list):
	for unit in removal_list:
		remove_unit(unit)

func remove_unit(unit, force_remove=false):
#	Terminal.add_log(Debug.ALL, Debug.MATCH, "Unit %s erased!" % unit.get_name_id())
	unit.get_hex().unit_logic = null
	if unit.display and (true if force_remove else unit.display.display_deletable()):
		unit.display.queue_free()
	unit_list.erase(unit)

## TILES

var tile_list = []

func get_tile_list():
	for tile in tile_list:
		if null == tile:
			Terminal.add_log(Debug.ERROR, Debug.MATCH, "Null in tile list!")
	return tile_list

func remove_all_tiles():
	for i in range(tile_list.size() - 1, -1, -1):
		remove_tile(tile_list[i])

func remove_tile_list(removal_list):
	for tile in removal_list:
		remove_tile(tile)

func remove_tile(tile, force_remove=false):
#	Terminal.add_log(Debug.ALL, Debug.MATCH, "Tile %s erased!" % tile.get_name_id())
	tile.get_hex().unit_logic = null
	if tile.display:
		tile.display.queue_free()
	tile_list.erase(tile)

##
