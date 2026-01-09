extends Node

# This is where global references to things could be stored. Such as:
# Storing global constants, like certain enums or other data.

# It CAN be used to as to store references to nodes that need to be globally accessible
# but this is a bit dangerous and often leads to bugs if you forget to set and clear them right.
# var player: Player = null
# then in player's _ready(): DataBus.player = self
# this is an alternative to using groups and get_first_node_in_group("player")


