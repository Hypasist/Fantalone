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