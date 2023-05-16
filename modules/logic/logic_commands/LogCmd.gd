class_name LogCmd

static func pack_command_name(log_command):
	return command_dictionary[log_command]

static func unpack_command_name(log_command_name):
	for command in command_dictionary:
		if command_dictionary[command] == log_command_name:
			return command

const command_dictionary = { \
	LogCmdDummy				:	"LogCmdDummy", \
	LogCmdFinishTurn		:	"LogCmdFinishTurn", \
	LogCmdNewMovement		:	"LogCmdNewMovement", \
	LogCmdConcludeAndSend	:	"LogCmdConcludeAndSend", \
	LogCmdConclude			:	"LogCmdConclude", \
	LogCmdSpellCreateUnit	:	"LogCmdSpellCreateUnit", \
	LogCmdSpellFreeze		:	"LogCmdSpellFreeze", \
}

const spells_dictionary = { \
	LogCmdSpellCreateUnit	:	"LogCmdSpellCreateUnit", \
	LogCmdSpellFreeze		:	"LogCmdSpellFreeze", \
#	LogCmdSpellTeleportUnit	:	"LogCmdSpellTeleportUnit", \
#	LogCmdSpelUntire		:	"LogCmdSpelUntire", \
}

static func get_spell_list():
	return spells_dictionary.keys()
