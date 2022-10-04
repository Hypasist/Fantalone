class_name MatchDataPackage

enum { _MATCH_INFO, _MATCH_UNITS, _MATCH_TILES }

static func pack_match():
	var package = {}

	package[_MATCH_UNITS] = []
	for unit in mod.MatchData.get_all_units():
		package[_MATCH_UNITS].append(unit.pack())
	
	package[_MATCH_TILES] = []
	for tile in mod.MatchData.get_all_tiles():
		package[_MATCH_TILES].append(tile.pack())
	
	var record = {}
	record["players_mana"] = mod.MatchData.get_players_mana()
	record["turn_owner"] = mod.MatchLogic.get_turn_owner()
	package[_MATCH_INFO] = record
	
	return package

static func unpack_match(package):
	for record in package[_MATCH_TILES]:
		mod.ObjectData.copy_object(record)
	
	for record in package[_MATCH_UNITS]:
		mod.ObjectData.copy_object(record)
	
	for record in package[_MATCH_UNITS]:
		for effect in record["effects"]:
			mod.ObjectData.copy_object(effect)
	
	mod.MatchData.set_players_mana(package[_MATCH_INFO]["players_mana"])
	mod.MatchLogic.set_turn_owner(package[_MATCH_INFO]["turn_owner"])
	
	mod.MapView.execute_display_queues()
