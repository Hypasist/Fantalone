class_name LogCmd

static func pack_command_name(log_command):
	return command_dictionary[log_command]

static func unpack_command_name(log_command_name):
	for command in command_dictionary:
		if command_dictionary[command] == log_command_name:
			return command

const command_dictionary = { \
	LogCmdDummy				:	"LogCmdDummy", \
	LogCmdCastSpell			:	"LogCmdCastSpell", \
	LogCmdFinishTurn		:	"LogCmdFinishTurn", \
	LogCmdEndGame			:	"LogCmdEndGame", \
	LogCmdNewMovement		:	"LogCmdNewMovement", \
	LogCmdConcludeAndSend	:	"LogCmdConcludeAndSend", \
	LogCmdConclude			:	"LogCmdConclude", \
}
