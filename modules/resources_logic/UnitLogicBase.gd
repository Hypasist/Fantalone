class_name UnitLogicBase
extends Node

var hex = null
var unitDisplay : UnitDisplayBase = null

var overseer = null
var grid = null

func setup(hex_):
	hex = hex_
	return self

func setup_display(scene:UnitDisplayBase):
	unitDisplay = scene.setup(self, hex)