class_name LobbyMemberInfo

const INVALID_NICKNAME = "-invalid lobby nickname-"
var nickname = INVALID_NICKNAME
var owned_match_members = []
var network_id = Network.INVALID_ID


func setup(_network_id=Network.INVALID_ID, _nickname=INVALID_NICKNAME):
	network_id = _network_id
	nickname = _nickname

func link_match_member(match_member):
	if not owned_match_members.has(match_member):
		owned_match_members.append(match_member)

func unlink_match_member(match_member):
	if owned_match_members.has(match_member):
		owned_match_members.erase(match_member)
