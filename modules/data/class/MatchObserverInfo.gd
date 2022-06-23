class_name MatchObserverInfo
extends MatchMemberInfo

func setup_new(_nickname=LobbyMemberInfo.INVALID_NICKNAME):
	unique_id = get_unique_id()
	setup_copy(unique_id, _nickname)
	
func setup_copy(_unique_id, _nickname=LobbyMemberInfo.INVALID_NICKNAME):
	nickname = _nickname
	unique_id = _unique_id
	_member_type = _MEMBER_TYPE_OBSERVER
