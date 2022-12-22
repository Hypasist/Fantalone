class_name MatchDataPackage

enum { _MATCH_INFO, _MATCH_UNITS, _MATCH_TILES }

## OTHER

static func get_current_hash():
	return pack_match().hash()

## PACK

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
	record["action_counter"] = mod.MatchLogic.get_action_counter()
	package[_MATCH_INFO] = record
	
	return package

static func hash_packed_match(packed_match):
	var new_hash = packed_match.hash()
	packed_match["hash"] = new_hash
	return packed_match

static func pack_hash_match():
	var packed_match = pack_match()
	return hash_packed_match(packed_match)

## UNPACK

static func unhash_package(hashed_package):
	var saved_hash = hashed_package[_MATCH_INFO]["hash"]
	hashed_package[_MATCH_INFO].erase("hash")
	return saved_hash

static func unpack_hash_match(hashed_package):
	var saved_hash = unhash_package(hashed_package)
	mod.MapView.setup_map(hashed_package)
	var new_hash = get_current_hash()
	if new_hash != saved_hash:
		Terminal.add_log(Debug.ERROR, Debug.MATCH_NETWORK, "Hash mishmatch! %s != %s")

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
	mod.MatchLogic.set_action_counter(package[_MATCH_INFO]["action_counter"])
	
	mod.MapView.execute_display_queues()
	mod.UI.update_ui()
