extends Node

func add_new(name, _arg1=null, _arg2=null, _arg3=null, _arg4=null):
	var resource = mod.Database.get_resource_by_name(name)
	match name:
		Resources.Ball:
			#qr_coords, owner_id
			var hex = mod.Logic.get_hex_by_xy_coords(_arg1)
			var unique_name = mod.MatchData.get_unique_name(name)
			var logic_scene = resource.logic_scene.new(unique_name, _arg2)
			mod.MatchData.register_new_unit(logic_scene)
			hex.place_unit(logic_scene)
			var display_scene = resource.display_scene.instance()
			display_scene.set_name(unique_name)
			logic_scene.assign_display_scene(display_scene)
			mod.MapView.add_unit_resource(display_scene)
		Resources.Water, Resources.Rocks, Resources.Grass:
			#qr_coords
			var hex = mod.Logic.get_hex_by_xy_coords(_arg1)
			var unique_name = mod.MatchData.get_unique_name(name)
			var logic_scene = resource.logic_scene.new(unique_name)
			mod.MatchData.register_new_tile(logic_scene)
			hex.place_tile(logic_scene)
			var display_scene = resource.display_scene.instance()
			display_scene.set_name(unique_name)
			logic_scene.assign_display_scene(display_scene)
			mod.MapView.add_tile_resource(display_scene)

