tool
class_name UnitDisplayBase
extends Node2D

var unitLogic = null

func setup(logic):
	mod.MapView.add_unit_resource(self)
	unitLogic = logic
	position = mod.Logic.hex_to_position(unitLogic.hex.coords)
	updateShadow()
	return self

func _on_Unit_mouse_entered():
	mod.UI.add_to_hoverlist(unitLogic)

func _on_Unit_mouse_exited():
	mod.UI.remove_from_hoverlist(unitLogic)

func move_to_hex(destination_hex):
	pass
#	hex.unit = null
#	hex = _hex
#	_hex.unit = self
#	position = grid.HEXToPosition(hex.coords)


# --- SHADOW HANDLE (export to shadow???) --- #
export (int) var heightBaseOffset = -15 setget setHeightBaseOffset
func setHeightBaseOffset(height):
	heightBaseOffset = height
	if $Unit: $Unit.set_position(Vector2(0, height))

export (float, 1) var shadowPerspectiveAspect = 0.4 setget setShadowPerspectiveAspect
func setShadowPerspectiveAspect(aspect):
	shadowPerspectiveAspect = aspect
	updateShadow()

export (int) var heightBaseShadowOffset = 10 setget setHeightBaseShadowOffset
func setHeightBaseShadowOffset(height):
	heightBaseShadowOffset = height
	updateShadow()

func updateShadow():
	if $Unit:
		var shadowBaseSize = $Unit/Sprite.get_texture().get_size()
		generateShadow($Shadow, Vector2(shadowBaseSize.x, shadowBaseSize.x * shadowPerspectiveAspect))
		$Shadow.set_position(Vector2(0, heightBaseShadowOffset))

func generateShadow(object:Sprite, size:Vector2):
	var imageTexture = ImageTexture.new()
	var dynImage = Image.new()
	dynImage.create(size.x, size.y, false, Image.FORMAT_RGB8)
	dynImage.fill(Color(1,0,0,1))
	imageTexture.create_from_image(dynImage)
	object.texture = imageTexture
