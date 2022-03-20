class_name LobbyMemberInfoPackage

static func pack(lobby):
	var package = []
#	player_list = lobby.LobbyPlayerInfo_dict.values().duplicate()
#	observer_list = lobby.LobbyObserverInfo_dict.values().duplicate()

	for member in lobby.LobbyPlayerInfo_dict.values():
		var record = {}
		record["id"] = member.id
		record["network_id"] = member.network_id
		record["type"] = member.type
		record["nickname"] = member.nickname
		record["color"] = member.color
		package.append(record)
	for member in lobby.LobbyObserverInfo_dict.values():
		var record = {}
		record["id"] = member.id
		record["network_id"] = member.network_id
		record["type"] = member.type
		record["nickname"] = member.nickname
		record["color"] = member.color
		package.append(record)
	return package
