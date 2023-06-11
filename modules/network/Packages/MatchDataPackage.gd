class_name MatchDataPackage

enum { _MATCH_INFO, _MATCH_UNITS, _MATCH_TILES }

static func pack_match(Data):
	var MatchData = Data.MatchData
	var package = {}

	package[_MATCH_UNITS] = []
	for unit in MatchData.get_all_units():
		package[_MATCH_UNITS].append(unit.pack())
	
	package[_MATCH_TILES] = []
	for tile in MatchData.get_all_tiles():
		package[_MATCH_TILES].append(tile.pack())
	
	var record = {}
	record["players_mana"] = MatchData.get_players_mana()
	record["turn_owner"] = MatchData.get_turn_owner()
	record["action_counter"] = MatchData.get_action_counter()
	package[_MATCH_INFO] = record
	
	return package


static func get_current_hash(Data):
	var current_hash = pack_match(Data).hash()
	if current_hash == null:
		Terminal.add_log(Debug.ERROR, Debug.QUEUE_NETWORK, "Hash is null!")
		breakpoint
	Terminal.add_log(Debug.ALL, Debug.QUEUE_NETWORK, "Hash is [%d]!" % current_hash)
	return current_hash


static func unpack_match(Data, package):
	var MatchData = Data.MatchData
	var ObjectData = Data.ObjectData
	
	for record in package[_MATCH_TILES]:
		ObjectData.copy_object(record)
	
	for record in package[_MATCH_UNITS]:
		ObjectData.copy_object(record)
	
	for record in package[_MATCH_UNITS]:
		for effect in record["effects"]:
			ObjectData.copy_object(effect)
	
	MatchData.set_players_mana(package[_MATCH_INFO]["players_mana"])
	MatchData.set_turn_owner(package[_MATCH_INFO]["turn_owner"])
	MatchData.set_action_counter(package[_MATCH_INFO]["action_counter"])
	
