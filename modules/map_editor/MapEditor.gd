tool
extends TileMap

func consumeMockup():
	consumeTileMockup()
	consumeUnitMockup()
	hide()

func get_used_ids(map:TileMap):
	var used_ids = {}
	var all_ids = map.tile_set.get_tiles_ids()
	for id in all_ids:
		var cells = map.get_used_cells_by_id(id)
		if cells: used_ids[id] = cells
	return used_ids

func consumeTileMockup():
	var tile_mapping = get_used_ids($Tiles)
	for id in tile_mapping:
		var resource = mod.Database.get_tile_resource(id)
		for coords in tile_mapping[id]:
			var hex = mod.Logic.get_hex_by_xy_coords(coords)
			var name_id = mod.Database.report_new_object(resource.display_scene)
			var logic_scene = resource.logic_scene.new(name_id)
			hex.add_resource(logic_scene)
			var display_scene = resource.display_scene.instance(PackedScene.GEN_EDIT_STATE_INSTANCE)
			hex.add_resource(display_scene)

func consumeUnitMockup():
	var unit_mapping = get_used_ids($Units)
	for owner_id in unit_mapping:
		var resource = mod.Database.get_unit_resource(0)
		for coords in unit_mapping[owner_id]:
			var hex = mod.Logic.get_hex_by_xy_coords(coords)
			var name_id = mod.Database.report_new_object(resource.display_scene)
			var logic_scene = resource.logic_scene.new(name_id, owner_id)
			hex.add_resource(logic_scene)
			var display_scene = resource.display_scene.instance(PackedScene.GEN_EDIT_STATE_INSTANCE)
			hex.add_resource(display_scene)

export (Vector2) var tilemapSize = Vector2(128, 70) setget updateTilemapSize
func updateTilemapSize(size):
	tilemapSize = size
	set_cell_size(size)
	$Tiles.set_cell_size(size)
	$Units.set_cell_size(size)
	$Props.set_cell_size(size)
