class_name Map
extends Node2D

func load_map(savefile:String = ""):
	if savefile == "":
		mod.MapEditor.consume_mockup()

func add_tile_resource(resource):
	$Tiles.add_child(resource)

func add_unit_resource(resource):
	$Units.add_child(resource)

func remove_tile_resources():
	var tile_array = $Tiles.get_children()
	for tile in tile_array:
		tile.free()

func remove_unit_resources():
	var unit_array = $Units.get_children()
	for unit in unit_array:
		unit.free()

func remove_all_resources():
	remove_tile_resources()
	remove_unit_resources()

func calculate_map_boundaries():
	var min_hex_coords = Vector2(INF, INF)
	var max_hex_coords = Vector2(-INF, -INF)
	var tiles = mod.MapView.get_display_tile_list()
	for tile in tiles:
		min_hex_coords = Utils.min2(min_hex_coords, tile.position)
		max_hex_coords = Utils.max2(max_hex_coords, tile.position)
	min_hex_coords -= mod.Database.get_tilesize()/2.0 \
	 				+ mod.Database.get_map_bounds_padding()
	max_hex_coords += mod.Database.get_tilesize()/2.0 \
	 				+ mod.Database.get_map_bounds_padding()
	mod.Database.set_min_map_boundaries(min_hex_coords)
	mod.Database.set_max_map_boundaries(max_hex_coords)

func calculate_map_center():
	pass
