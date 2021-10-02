extends Node

const MAX_PLAYER_NUM = 8


var GameServant = null
var GameOptions = null
var MatchServant = null
var MatchOptions = null
var InputServant = null
var Game = null
var Match = null
var Logic = null
var MapEditor = null
var Worldview = null
var Worldmap = null
var UI = null


# Player Options
const colorList = [ Color.steelblue, Color.webmaroon, Color.coral, Color.darkgreen ]


# Menus
enum { MAIN_SCREEN, MATCH_SETUP }
var menuScreens = {
	MAIN_SCREEN : "res://game/menu/Main.tscn",
	MATCH_SETUP : "res://game/menu/MatchSetup/MatchSetup.tscn"
	}
enum { CHANGE_SCREEN, UPDATE_OPTIONS, START_MATCH }