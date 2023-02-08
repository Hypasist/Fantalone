class_name MapView
extends Node2D

func setup_map():
	hide()
	$MapControl.setup()
	$Map.calculate_map_boundaries()
	show()

func zoom(_center, zoom_value, isStep=false):
	$MapControl.zoom(_center, zoom_value, isStep)
func scroll(scrollValue):
	$MapControl.scroll(scrollValue)

func add_tile_resource(resource):
	$Map.add_tile_resource(resource)
func add_unit_resource(resource):
	$Map.add_unit_resource(resource)
func get_display_tile_list():
	return $Map/Tiles.get_children()
func get_display_unit_list():
	return $Map/Units.get_children()
	
func execute_display_queues():
	$DisCmdManager.execute_display_queues()
