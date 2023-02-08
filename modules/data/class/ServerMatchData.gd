class_name ServerMatchData
extends MatchData

func start_match():
	setup()
	mod.MapEditor.consume_mockup(mod.ServerData.LobbyData, self)
	mod.ServerData.MatchData.determine_next_turn_owner()
	mod.MatchNetworkAPI.broadcast_to_clients(MatchNetworkAPI.command.START_MATCH, \
										MatchDataPackage.pack(mod.ServerData.MatchData))
#	mod.MatchNetworkAPI.broadcast_to_clients(MatchNetworkAPI.command.UPDATE_MATCH_STATUS, \
#										MatchDataPackage.pack(mod.ServerData.MatchData))

func stop_match():
	Terminal.add_log(Debug.INFO, Debug.MATCH, "Match stopped.")
#	mod.Network.disconnect_()
