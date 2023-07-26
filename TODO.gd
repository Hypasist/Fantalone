#Notes
# - make move option a separate logcmd
# - make optional argument to logcmd (to be subcommands)
#   difference between sub and non-sub should be that only non-sub are sent
#	via multiplayer
# - move ball color mod inside Unit node
# - expand unit animation manager 
# - End Match Server command needs to be separate queue package
# - if spell has multiple target selection, it will not deselect properly on spell cancel
#	thats because selected_tiles is not cleared properly (because therwise multiplayer pack wont work
# - cooldowns not working
# - cancel selection button
# - start turn anew button
# - chance 'packing' and 'unpacking' to serialize/deserialize 
