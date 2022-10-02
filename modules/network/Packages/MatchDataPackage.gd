class_name MatchDataPackage

enum { _MATCH_INFO, _MATCH_UNITS }

static func pack_match():
	var package = {}

	package[_MATCH_UNITS] = []
	for member in mod.LobbyData.get_players():
		var record_player = {}
		for unit in mod.MatchData.get_players_units(member.match_id):
			var record_unit = {}
			var packed_effects = []
			for effect in unit.effect_list:
				packed_effects.append(effect.pack())
			record_unit["effects"] = packed_effects
			record_unit["marked_to_delete"] = unit.is_marked_to_delete()
			record_unit["hex"] = unit.get_hex().pack()
			
			record_player[member.match_id] = record_unit
			#TUTEJ ZAPISZ
		package[_MATCH_UNITS] = record_player
	
	var record = {}
	record["players_mana"] = mod.MatchData.get_players_mana()
	record["turn_owner"] = mod.MatchLogic.get_turn_owner()
	package[_MATCH_INFO] = record
		
	return package

static func unpack_match(package):
	return 
	for record in package[_MATCH_UNITS]:
		var new_member = LobbyMemberInfo.new()
		new_member.setup(record["network_id"], record["nickname"])
