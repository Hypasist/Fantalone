tool
class_name ActorBase
extends Node2D

var overseer = null
var grid = null
var hex = null

var color : Color = Color.white
var ownerId = null
var selected = false

func setup(_info):
	ownerId = _info["owner"]
	color = _info["color"]
	overseer = _info["overseer"]
	grid = _info["HEXgrid"]
	position = grid.squareToPosition(_info["coords"])
	
func assignHEX(_hex):
	hex = _hex

func move(_hex):
	hex.actor = null
	hex = _hex
	_hex.actor = self
	position = grid.HEXToPosition(hex.coords)

func _ready():
	set_modulate(color.darkened(0.2))
	updateShadow()

# --- SHADOW HANDLE (export to shadow???) --- #
export (int) var heightBaseOffset = -15 setget setHeightBaseOffset
func setHeightBaseOffset(height):
	heightBaseOffset = height
	if $Actor: $Actor.set_position(Vector2(0, height))

export (float, 1) var shadowPerspectiveAspect = 0.4 setget setShadowPerspectiveAspect
func setShadowPerspectiveAspect(aspect):
	shadowPerspectiveAspect = aspect
	updateShadow()

export (int) var heightBaseShadowOffset = 10 setget setHeightBaseShadowOffset
func setHeightBaseShadowOffset(height):
	heightBaseShadowOffset = height
	updateShadow()

func updateShadow():
	if $Actor:
		var shadowBaseSize = $Actor/Sprite.get_texture().get_size()
		generateShadow($Shadow, Vector2(shadowBaseSize.x, shadowBaseSize.x * shadowPerspectiveAspect))
		$Shadow.set_position(Vector2(0, heightBaseShadowOffset))

func generateShadow(object:Sprite, size:Vector2):
	var imageTexture = ImageTexture.new()
	var dynImage = Image.new()
	
	dynImage.create(size.x, size.y, false, Image.FORMAT_RGB8)
	dynImage.fill(Color(1,0,0,1))
	
	imageTexture.create_from_image(dynImage)
	object.texture = imageTexture

func _on_Actor_mouse_entered():
	overseer.add_to_hoverlist(self)

func _on_Actor_mouse_exited():
	overseer.remove_from_hoverlist(self)

func select():
	if !selected:
		selected = true
		set_modulate(color.lightened(0.2))
	
func deselect():
	if selected:
		selected = false
		set_modulate(color.darkened(0.2))
