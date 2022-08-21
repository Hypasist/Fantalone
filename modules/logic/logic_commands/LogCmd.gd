class_name LogCmd

static func pack(log_cmd):
	return pack_dictionary[log_cmd]

static func unpack(pack):
	for cmd in pack_dictionary:
		if pack_dictionary[cmd] == pack:
			return cmd

const pack_dictionary = { \
	LogCmdDummy				:	"LogCmdDummy", \
	LogCmdGetPushedAndDie	:	"LogCmdGetPushedAndDie", \
	LogCmdGetPushedToEmpty	:	"LogCmdGetPushedToEmpty", \
	LogCmdMoveAndDie		:	"LogCmdMoveAndDie", \
	LogCmdMoveAndPush		:	"LogCmdMoveAndPush", \
	LogCmdMoveToEmpty		:	"LogCmdMoveToEmpty",
}
