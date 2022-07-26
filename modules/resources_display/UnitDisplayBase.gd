class_name UnitDisplayBase
extends Node2D

var unitLogic = null
func assign_logic_scene(logic_scene):
	unitLogic = logic_scene
	position = mod.Logic.hex_to_position(unitLogic.get_hex().get_coords())
	updateShadow()

func _on_Unit_mouse_entered():
	mod.UI.add_to_hoverlist(unitLogic)
func _on_Unit_mouse_exited():
	mod.UI.remove_from_hoverlist(unitLogic)

# --- COMMAND QUEUE HANDLING --- #
var _command_queue = []
var _comp_object = null
var _comp_method = null

func queue_command(display_command):
	_command_queue.push_back(display_command)
func has_commands_queued():
	return _command_queue.empty() == false
func execute_display_queue(comp_object, comp_method):
	_comp_object = comp_object
	_comp_method = comp_method
	execute_display_command()
func execute_display_command():
	var command = _command_queue.pop_front()
	if command:
		command.connect("command_completed", self, "execute_display_command")
		command.execute()
	else:
		_comp_object.call(_comp_method)
	

# --- SHADOW HANDLE (export to shadow???) --- #
export (int) var heightBaseOffset = -15
export (float, 1) var shadowPerspectiveAspect = 0.4
export (int) var heightBaseShadowOffset = 10
func updateShadow():
	$Unit.set_position(Vector2(0, heightBaseOffset))
	var shadowBaseSize = $Unit/AnimatedSprite.get_sprite_frames().get_frame("default", 0).get_size()
	generateShadow($Shadow, Vector2(shadowBaseSize.x, shadowBaseSize.x * shadowPerspectiveAspect))
	$Shadow.set_position(Vector2(0, heightBaseShadowOffset))

func generateShadow(object:Sprite, size:Vector2):
	var imageTexture = ImageTexture.new()
	var dynImage = Image.new()
	dynImage.create(size.x, size.y, false, Image.FORMAT_RGB8)
	dynImage.fill(Color(1,0,0,1))
	imageTexture.create_from_image(dynImage)
	object.texture = imageTexture
