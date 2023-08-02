class_name UnitDisplayBase
extends ObjectDisplayBase

func assign_logic_scene(logic_scene):
	.assign_logic_scene(logic_scene)
	update_shadow()


# --- SHADOW HANDLE (export to shadow???) --- #
export (int) var heightBaseOffset = -15
export (float, 1) var shadowPerspectiveAspect = 0.4
export (int) var heightBaseShadowOffset = 10
func update_shadow():
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
