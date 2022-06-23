class_name MatchMemberInfo

var owner_lobby_member = null

var nickname = LobbyMemberInfo.INVALID_NICKNAME

const ID_INVALID = -1
var unique_id = ID_INVALID

enum { _MEMBER_TYPE_MEMBER, _MEMBER_TYPE_PLAYER, _MEMBER_TYPE_OBSERVER }
var _member_type = _MEMBER_TYPE_MEMBER

func get_unique_id():
	return mod.LobbyData.get_new_unique_id()

func link_lobby_member(lobby_member):
	owner_lobby_member = lobby_member

func is_observer():
	return _member_type == _MEMBER_TYPE_OBSERVER
	
func is_player():
	return _member_type == _MEMBER_TYPE_PLAYER
