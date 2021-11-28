class_name CommandInfo

# only valid fates here!
enum unit_commands {
	unevaluated,
	move_to_empty,
	move_and_push,
	move_and_die,
	get_pushed_to_empty,
	get_pushed_and_die }

var target = null
var current_hex = null
var destination_hex = null
var command = null

func _init(target_, destination_hex_, command_):
	target = target_
	current_hex = target.hex
	destination_hex = destination_hex_
	command = command_

func setup(destination_hex_, command_):
	destination_hex = destination_hex_
	command = command_

func execute():
	target.handle_command(self)