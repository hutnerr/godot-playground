class_name Attack extends Node

var attackDamage: float = 10.0
var knockback: float = 100.0
var attackPosition: Vector2 = Vector2(0, 0)

# its better to instantiate and use an object like this to pass information
# about an attack. The reason for this is that it simplifies your functions
# and the bodies who implement the recieveDamage function can use what they 
# want out of it. 

# for example, you call damage(attack: Attack), then the body selects the vars
# that are relevant to how it is supposed to behave. 

# this also means if you want to change or add something, you simply have to add
# a variable here and you don't have to change everything else you've written
# regarding Attacking and taking damage

# the way you would use this is on a weapon for example, you'd calculate the damage 
# that needs to be taken using the weapons parameters/values, then create a new
# attack object and set the relevant values to you

# var attack = Attack.new()
# attack.attackDamage = CALCUATED
# attack.attack_position = global_position
# body.damage(attack)
