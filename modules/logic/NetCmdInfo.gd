class_name NetCmdInfo


const command_dictionary = { \
	NetCmdFinishTurn	:	"NetCmdFinishTurn", \
	NetCmdNewMovement	:	"NetCmdNewMovement", \
#	NetCmdNewMovement  		:	"NetCmdNewMovement", \
#	NetCmdCastSpell			:	"NetCmdCastSpell", \
}

static func get_command_name(command_class):
	return command_dictionary[command_class]

static func get_command_class(command_name):
	for key in command_dictionary:
		if command_dictionary[key] == command_name:
			return key
