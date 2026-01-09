using Godot;

namespace Toolbox.GameLogic;

/// <summary>
/// This class is intended to be passed around and extended based on the
/// combat system of the game. 
/// 
/// The benefit of this structure is that you can have methods like
/// body.TakeDamage(attack: Attack)
/// instead of
/// body.TakeDamage(damageAmount: float, isCritical: bool, ...)
/// 
/// If there are additional properties here, the reciever can only
/// take out what they need and leave the rest alone. This makes
/// it very easy to extend without breaking anything.
/// 
/// var attack = new Attack
/// {
/// 	damage = calculatedDamage,
/// 	critical = False,
/// 	knockback = 150.0f,
/// }
/// body.takeDamage(attack);
/// </summary>
public partial class Attack
{
	public double damage { get; set; }
	public bool critical { get; set; }
	// add more parameters as necessary

	public Attack() : this(0.0) {}

	public Attack(double damage)
	{
		this.damage = damage;
	}
}
