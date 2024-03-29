class_name Map
extends Node2D

func load_map(savefile:String = ""):
	if savefile == "":
		mod.MapEditor.consume_mockup()

func add_tile_resource(resource):
	$Tiles.add_child(resource)

func add_unit_resource(resource):
	$Units.add_child(resource)

func calculate_map_boundaries():
	var min_hex_coords = Vector2(INF, INF)
	var max_hex_coords = Vector2(-INF, -INF)
	var tiles = mod.MapView.get_display_tile_list()
	for tile in tiles:
		min_hex_coords = Utils.min2(min_hex_coords, tile.position)
		max_hex_coords = Utils.max2(max_hex_coords, tile.position)
	min_hex_coords -= mod.Graphics.get_tilesize()/2.0 \
	 				+ mod.Graphics.get_map_bounds_padding()
	max_hex_coords += mod.Graphics.get_tilesize()/2.0 \
	 				+ mod.Graphics.get_map_bounds_padding()
	mod.Graphics.set_min_map_boundaries(min_hex_coords)
	mod.Graphics.set_max_map_boundaries(max_hex_coords)
	mod.Graphics.set_map_center((max_hex_coords + min_hex_coords)/2)
