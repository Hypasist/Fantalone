tool
extends TileMap

const recognizedTiles = {
	"Grass":preload("res://map/tiles/GrassTile.tscn"),
	"Water":preload("res://map/tiles/WaterTile.tscn"),
	"Rocks":preload("res://map/tiles/RocksTile.tscn")
}
func getTileTable():
	var returnTable = []
	for i in recognizedTiles.size():
		var key = recognizedTiles.keys()[i]
		var tileScene = recognizedTiles[key]
		var tileHEXpositions = $Tiles.get_used_cells_by_id(i)
		returnTable.push_back({"key"	:	key,
							   "scene"	:	tileScene,
							   "positionList"	:	tileHEXpositions})
	$Tiles.set_visible(false)
	return returnTable


const recognizedActors = {
	"Player":preload("res://actors/PlayerBall.tscn"),
	"Enemy":preload("res://actors/EnemyBall.tscn")
}
func getActorTable():
	var returnTable = []
	for i in recognizedActors.size():
		var key = recognizedActors.keys()[i]
		var actorScene = recognizedActors[key]
		var actorHEXpositions = $Actors.get_used_cells_by_id(i)
		returnTable.push_back({"key"	:	key,
							   "scene"	:	actorScene,
							   "positionList"	:	actorHEXpositions})
	$Actors.set_visible(false)
	return returnTable

const recognizedProps = {
#	"Player":preload("res://actors/PlayerBall.tscn"),
#	"Enemy":preload("res://actors/EnemyBall.tscn")
}
func getPropsTable():
	var returnTable = []
	for i in recognizedProps.size():
		var key = recognizedProps.keys()[i]
		var propsScene = recognizedProps[key]
		var propsHEXpositions = $Props.get_used_cells_by_id(i)
		returnTable.push_back({"key"	:	key,
							   "scene"	:	propsScene,
							   "positionList"	:	propsHEXpositions})
	$Props.set_visible(false)
	return returnTable


export (Vector2) var tilemapSize = Vector2(128, 70) setget updateTilemapSize
func updateTilemapSize(size):
	tilemapSize = size
	set_cell_size(size)
	$Tiles.set_cell_size(size)
	$Actors.set_cell_size(size)
	$Props.set_cell_size(size)