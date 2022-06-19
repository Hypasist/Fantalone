class_name MatchPlayerInfo
extends MatchMemberInfo

var match_id = ID_INVALID

const COLOR_INVALID = Color.transparent
var color = COLOR_INVALID

enum { HUMAN_PLAYER, CPU_PLAYER }
var player_type = CPU_PLAYER

func setup_new(_match_id=ID_INVALID, _nickname=LobbyMemberInfo.INVALID_NICKNAME, _color=COLOR_INVALID, _player_type=HUMAN_PLAYER):
	var _unique_id = get_unique_id()
	if _match_id == ID_INVALID:
		_match_id = mod.LobbyData.get_first_unused_match_id()
	setup_copy(_unique_id, _match_id, _nickname, _color, _player_type)

func setup_copy(_unique_id, _match_id, _nickname, _color, _player_type):
	unique_id = _unique_id
	match_id = _match_id
	nickname = _nickname
	color = _color
	player_type = _player_type

func link_lobby_member(lobby_member):
	owner_lobby_member = lobby_member
