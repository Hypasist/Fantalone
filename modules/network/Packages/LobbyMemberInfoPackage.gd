class_name LobbyMemberInfoPackage

static func pack(lobby):
	var package = []

	for member in lobby.LobbyMemberInfo_dict.values():
		var record = {}
		record["id"] = member.id
		record["network_id"] = member.network_id
		record["type"] = member.type
		record["nickname"] = member.nickname
		record["color"] = member.color
		record["player_type"] = member.player_type
		package.append(record)
	return package
