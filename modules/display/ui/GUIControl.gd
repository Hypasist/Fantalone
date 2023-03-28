class_name GUIControl
extends Node

## INFORMING THE PLAYER ABOUT THE MOVE RESULTS:
## 	IF VALID:
##   	- the *destination* tile should have a color (OR ONLY BLUE??) of the incoming HEX
##		- if the *destination* tile is a lethal hex, present a skull
##	IF INVALID:
##		IF NO_REASON:
##			assert?
##		IF UNPASSABLE TERRAIN:
##			red cage on the unpassable terrain?, blue tile on any affected?
##		IF PUSHING OWN UNITS:
##			red cage on mentioned own unit, blue tile under any affected
##		IF FORMATION TOO WEAK:
##			RED CAGE on first invalid enemy hex, rest with blue tile under
##		IF TILE OCCUPIED:
##			red cage on tiles uccupied, blue tiles under own hexes

