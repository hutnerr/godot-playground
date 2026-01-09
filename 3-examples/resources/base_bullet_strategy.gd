class_name BaseBulletStrategy extends Resource

# this should have other types of upgrades that extend it, for example
# DamageBulletStrategy, PierceBulletStrategy, SpeedBulletStrategy
# which have their own params, etc and they override the applyUpgrade 
# with their parameters.

# you can then make .tres resources using these for special upgrades. 
# You then have an upgrade scene which takes in a BaseBulletStrategy resource

@export var texture: Texture2D = preload("res://99-assets/weapons/dagger.png")
@export var upgradeText: String = "Speed"

# the way this would work is it is an upgrade to be collected by the player
# the player stores a list of all upgrades, and when they shoot, they can
# loop over all the upgrades and call applyUpgrade on their bullet.
func applyUpgrade(bullet):
	pass

# some other functionality that can be added
func applyToHit(enemy):
	pass
