extends Node

# This is where global references to things could be stored. Such as:
# var player: Player = null
# then in player's _ready(): DataBus.player = self
# this is an alternative to using groups and get_first_node_in_group("player")
# It is also helpful for storing global constants, like certain enums or other data.
