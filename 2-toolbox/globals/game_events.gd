extends Node

# game events is essentially a global signal bus for things that don't
# naturally belong to a specific node. for example:
# signal playerDied
# signal levelCompleted
# then any node can emit GameEvents.playerDied.emit()
# and any node can connect to it by GameEvents.playerDied.connect(method)

