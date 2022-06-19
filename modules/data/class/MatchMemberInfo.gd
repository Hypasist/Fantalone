class_name MatchMemberInfo

var owner_lobby_member = null

var nickname = LobbyMemberInfo.INVALID_NICKNAME

const ID_INVALID = -1
var unique_id = ID_INVALID

func get_unique_id():
	return mod.LobbyData.get_new_unique_id()

func link_lobby_member(lobby_member):
	owner_lobby_member = lobby_member
