extends Node

func add_new(name, arg1=null, arg2=null, arg3=null, arg4=null):
	var resource = mod.Database.get_resource_by_name(name)
	match name:
		Resources.Ball:
			#qr_coords, owner_id
			var hex = mod.Logic.get_hex_by_xy_coords(arg1)
			var unique_name = mod.Database.get_unique_name(name)
			var logic_scene = resource.logic_scene.new(unique_name, arg2)
			hex.place_unit(logic_scene)
			var display_scene = resource.display_scene.instance(PackedScene.GEN_EDIT_STATE_INSTANCE)
			logic_scene.assign_display_scene(display_scene)
			mod.MapView.add_unit_resource(display_scene)
		Resources.Water, Resources.Rocks, Resources.Grass:
			#qr_coords
			var hex = mod.Logic.get_hex_by_xy_coords(arg1)
			var unique_name = mod.Database.get_unique_name(name)
			var logic_scene = resource.logic_scene.new(unique_name)
			hex.place_tile(logic_scene)
			var display_scene = resource.display_scene.instance(PackedScene.GEN_EDIT_STATE_INSTANCE)
			logic_scene.assign_display_scene(display_scene)
			mod.MapView.add_tile_resource(display_scene)

func new_ball(coords, owner_id):
	pass
