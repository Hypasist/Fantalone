class_name LobbyMemberInfo

const ID_INVALID = -1
var id = ID_INVALID

const NETWORK_ID_INVALID = -1
const NETWORK_ID_SERVER = 1
var network_id = NETWORK_ID_INVALID

const TYPE_PLAYER = 0
const TYPE_OBSERVER = 1
var type = TYPE_OBSERVER

var nickname = ""

const COLOR_INVALID = Color.transparent
var color = COLOR_INVALID

enum { HUMAN_PLAYER, CPU_PLAYER }
var player_type = CPU_PLAYER

func setup(_id, _network_id, _type, _nickname, _color=COLOR_INVALID, _player_type=HUMAN_PLAYER):
	id = _id
	network_id = _network_id
	type = _type
	if _nickname:
		nickname = _nickname
	if _color:
		color = _color
	if _player_type:
		player_type = _player_type
