class_name MatchDataPackage

enum { _LOBBY_MEMBER_RECORDS, _MATCH_OBSERVER_RECORDS, _MATCH_PLAYER_RECORDS }

static func pack(lobby):
	var package = {}

	package[_LOBBY_MEMBER_RECORDS] = []
	for member in lobby.LobbyMemberInfo_dict.values():
		var record = {}
		record["network_id"] = member.network_id
		record["nickname"] = member.nickname
		record["owned_members"] = []
		for owned_member in member.owned_match_members:
			record["owned_members"].append(owned_member.unique_id)
		package[_LOBBY_MEMBER_RECORDS].append(record)
	
	package[_MATCH_PLAYER_RECORDS] = []
	for member in lobby.MatchPlayerInfo_dict.values():
		var record = {}
		record["unique_id"] = member.unique_id
		record["match_id"] = member.match_id
		record["nickname"] = member.nickname
		record["color"] = member.color
		record["player_type"] = member.player_type
		package[_MATCH_PLAYER_RECORDS].append(record)
	
	package[_MATCH_OBSERVER_RECORDS] = []
	for member in lobby.MatchObserverInfo_dict.values():
		var record = {}
		record["unique_id"] = member.unique_id
		record["nickname"] = member.nickname
		package[_MATCH_OBSERVER_RECORDS].append(record)
		
	return package

static func unpack(lobby, package):
	for record in package[_MATCH_PLAYER_RECORDS]:
		var new_member = MatchPlayerInfo.new()
		new_member.setup_copy(record["unique_id"], record["match_id"], \
			record["nickname"], record["color"], record["player_type"])
		lobby.reserve_color(new_member.color, new_member.match_id)
		lobby.MatchPlayerInfo_dict[new_member.unique_id] = new_member
	
	for record in package[_MATCH_OBSERVER_RECORDS]:
		var new_member = MatchObserverInfo.new()
		new_member.setup_copy(record["unique_id"], record["nickname"])
		lobby.MatchObserverInfo_dict[new_member.unique_id] = new_member
		
	for record in package[_LOBBY_MEMBER_RECORDS]:
		var new_member = LobbyMemberInfo.new()
		new_member.setup(record["network_id"], record["nickname"])
		lobby.LobbyMemberInfo_dict[new_member.network_id] = new_member
		for unique_id in record["owned_members"]:
			lobby.link_lobby_and_match_members(new_member.network_id, unique_id)
