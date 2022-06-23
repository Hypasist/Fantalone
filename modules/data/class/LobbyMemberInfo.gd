class_name LobbyMemberInfo

const INVALID_NICKNAME = "-invalid lobby nickname-"
var nickname = INVALID_NICKNAME
var owned_match_members = []
var owned_players = []
var owned_observers = []
var network_id = Network.INVALID_ID


func setup(_network_id=Network.INVALID_ID, _nickname=INVALID_NICKNAME):
	network_id = _network_id
	nickname = _nickname

func link_match_member(match_member):
	if not owned_match_members.has(match_member):
		owned_match_members.append(match_member)
		if match_member.is_observer():
			owned_observers.append(match_member)
		if match_member.is_player():
			owned_players.append(match_member)			

func unlink_match_member(match_member):
	if owned_match_members.has(match_member):
		if owned_players.has(match_member):
			owned_players.erase(match_member)
		if owned_observers.has(match_member):
			owned_observers.erase(match_member)
		owned_match_members.erase(match_member)
