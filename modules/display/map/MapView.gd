extends Node2D

func setup():
	$MapControl.setup()
	$Map.setup()

func zoom(_center, zoom_value, isStep=false):
	$MapControl.zoom(_center, zoom_value, isStep)
func scroll(scrollValue):
	$MapControl.scroll(scrollValue)

func add_tile_resource(resource):
	$Map.add_tile_resource(resource)
func add_unit_resource(resource):
	$Map.add_unit_resource(resource)
func get_tile_list():
	return $Map/Units.get_children()
func get_unit_list():
	return $Map/Units.get_children()
	
func execute_display_queues():
	$DisCmdManager.execute_display_queues()
