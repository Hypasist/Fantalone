class_name ObjectData
extends Node

var item_counter = {}
func get_unique_name(name):
	if item_counter.has(name):
		item_counter[name] = item_counter[name] + 1
	else:
		item_counter[name] = 0
	return "%s_%03d" % [name, item_counter[name]]

func create_new_object(name, _arg1=null, _arg2=null, _arg3=null, _arg4=null):
	var resource = mod.Database.get_resource_by_name(name)
	match name:
		Resources.Ball:
			#qr_coords, owner_id
			var hex = mod.Logic.get_hex_by_xy_coords(_arg1)
			var unique_name = get_unique_name(name)
			var logic_scene = resource.logic_scene.new(unique_name, _arg2)
			unit_list.append(logic_scene)
			hex.place_unit(logic_scene)
			var display_scene = resource.display_scene.instance()
			display_scene.set_name(unique_name)
			logic_scene.assign_display_scene(display_scene)
			mod.MapView.add_unit_resource(display_scene)
		Resources.Water, Resources.Rocks, Resources.Grass:
			#qr_coords
			var hex = mod.Logic.get_hex_by_xy_coords(_arg1)
			var unique_name = get_unique_name(name)
			var logic_scene = resource.logic_scene.new(unique_name)
			tile_list.append(logic_scene)
			hex.place_tile(logic_scene)
			var display_scene = resource.display_scene.instance()
			display_scene.set_name(unique_name)
			logic_scene.assign_display_scene(display_scene)
			mod.MapView.add_tile_resource(display_scene)

func remove_all_objects():
	remove_all_units()
	remove_all_tiles()

## UNITS

var unit_list = []

func get_unit_list():
	for unit in unit_list:
		if null == unit:
			Terminal.add_log(Debug.ERROR, Debug.MATCH, "Null in unit list!")
	return unit_list

func remove_all_units():
	for i in range(unit_list.size() - 1, -1, -1):
		remove_unit(unit_list[i])

func remove_unit_list(removal_list):
	for unit in removal_list:
		remove_unit(unit)

func remove_unit(unit):
	Terminal.add_log(Debug.ALL, Debug.MATCH, "Unit %s erased!" % unit.get_name_id())
	unit.get_hex().unit_logic = null
	if unit.display and unit.display.display_deletable():
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


func remove_tile(tile):
	Terminal.add_log(Debug.ALL, Debug.MATCH, "Tile %s erased!" % tile.get_name_id())
	tile.get_hex().unit_logic = null
	if tile.display:
		tile.display.queue_free()
	tile_list.erase(tile)

##
