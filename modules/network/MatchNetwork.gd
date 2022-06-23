class_name MatchNetwork
extends Node

enum command { \
	BROADCAST_MOVE, \
	BROADCAST_TURN_OWNER, \
	BROADCAST_LOG_CMD, \
	UPDATE_TURN_OWNER, \
	VERIFY_MOVE, \
	DISCARD_MOVE, \
	REQUEST_MOVE, \
	EXECUTE_MOVE, \
	EXECUTE_LOG_CMD, \
}

const server_commands = [ \
	command.BROADCAST_MOVE, \
	command.BROADCAST_TURN_OWNER, \
	command.BROADCAST_LOG_CMD, \
	command.VERIFY_MOVE, \
	command.DISCARD_MOVE, \
]

func setup():
	rpc_config("match_network_execute_command", MultiplayerAPI.RPC_MODE_SYNC)

func execute_command(cmd, param1=null, param2=null, param3=null, param4=null):
	match_network_execute_command(cmd, param1, param2, param3, param4)
	
func match_network_execute_command(cmd, param1=null, param2=null, param3=null, param4=null):
	# check rights
	if not command.values().has(cmd):
		Terminal.add_log(Terminal.ERROR, "Trying to execute incoming unknown (%d) command!" % cmd)
		return
	if server_commands.has(cmd) and not mod.Network.is_server():
		Terminal.add_log(Terminal.ERROR, "Trying to execute server command (%s) while being a client!" % command.keys()[cmd])
		return
	Terminal.add_log(Terminal.INFO, "Executing command %s!" % command.keys()[cmd])
	
	var network_id = get_tree().get_rpc_sender_id()
	match cmd:
		command.BROADCAST_MOVE:
			var unit_ids = mod.Database.pack_unit_ids(param1)
			rpc("match_network_execute_command", command.EXECUTE_MOVE, unit_ids, param2)
		command.BROADCAST_LOG_CMD: 
			# Needs to be packed before
			rpc("match_network_execute_command", command.EXECUTE_LOG_CMD, param1)
		command.BROADCAST_TURN_OWNER:
			rpc("match_network_execute_command", command.UPDATE_TURN_OWNER, mod.MatchLogic.get_turn_owner())
		command.UPDATE_TURN_OWNER:
			mod.MatchLogic.set_turn_owner(param1)
			mod.UI.update_ui()
		command.VERIFY_MOVE:
			var unit_list = mod.Database.unpack_unit_ids(param1)
			var movement = mod.MatchLogic.verify_move(unit_list, param2)
			if movement.is_valid():
				mod.MatchLogic.move_confirmed(unit_list, param2)
			else:
				rpc_id(network_id, "match_network_execute_command", command.DISCARD_MOVE, movement.invalid_reason)
		command.REQUEST_MOVE:
			var unit_ids = mod.Database.pack_unit_ids(param1)
			rpc_id(mod.Network.SERVER_ID, "match_network_execute_command", command.VERIFY_MOVE, unit_ids, param2)
		command.DISCARD_MOVE:
			Terminal.add_log(Debug.INFO, "Server says: invalid move: %s" % MovementInfo.invalid.keys()[param1])
		command.EXECUTE_MOVE:
			var unit_list = mod.Database.unpack_unit_ids(param1)
			mod.MatchLogic.make_move(unit_list, param2)
		command.EXECUTE_LOG_CMD:
			mod.MatchLogic.execute_log_cmd(param1)

