class_name MatchObserverInfo
extends MatchMemberInfo

func setup_new(_nickname=LobbyMemberInfo.INVALID_NICKNAME):
	nickname = _nickname
	unique_id = get_unique_id()
	
func setup_copy(_unique_id, _nickname=LobbyMemberInfo.INVALID_NICKNAME):
	nickname = _nickname
	unique_id = _unique_id
