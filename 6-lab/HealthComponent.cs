using Godot;

[GlobalClass]
public partial class HealthComponent : Node
{
	[Signal] public delegate void DiedEventHandler();
	[Signal] public delegate void HealthChangedEventHandler(float previousHealth, float currentHealth);

	[Export] public float MaxHealth { get; set; } = 100f;

	public float CurrentHealth { get; private set; }

	public override void _Ready()
	{
		CurrentHealth = MaxHealth;
	}

	public void Hurt(float amount)
	{
		var previousHealth = CurrentHealth;
		CurrentHealth = Mathf.Max(CurrentHealth - amount, 0);
		EmitSignal(SignalName.HealthChanged, previousHealth, CurrentHealth);
		if (CurrentHealth <= 0) EmitSignal(SignalName.Died);
	}

	public void Heal(float amount)
	{
		var previousHealth = CurrentHealth;
		CurrentHealth = Mathf.Min(CurrentHealth + amount, MaxHealth);
		EmitSignal(SignalName.HealthChanged, previousHealth, CurrentHealth);
	}
}
