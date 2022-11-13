class_name LogCmd

static func pack_command_name(log_cmd):
	return command_dictionary[log_cmd]

static func unpack(pack):
	for cmd in command_dictionary:
		if command_dictionary[cmd] == pack:
			return cmd

const command_dictionary = { \
	LogCmdCastSpell			:	"LogCmdCastSpell", \
	LogCmdFinishTurn		:	"LogCmdFinishTurn", \
	LogCmdNewMovement		:	"LogCmdNewMovement",
}

static func is_queue_trigger(command_class):
	return queue_trigger_commands.has(command_class)
const queue_trigger_commands = [
	LogCmdFinishTurn
	]
