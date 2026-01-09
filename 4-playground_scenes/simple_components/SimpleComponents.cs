using Godot;
using System;
using Toolbox;

public partial class SimpleComponents : Node2D
{
	
	private Label HealthLabel;
	private HealthComponent HealthComp;
	private Button HurtButton;
	private Button HealButton;

	public override void _Ready()
	{
		HealthLabel = GetNode<Label>("CanvasLayer/HealthLabel");
		HealthComp = GetNode<HealthComponent>("HealthComponent");
		HurtButton = GetNode<Button>("CanvasLayer/HurtButton");
		HealButton = GetNode<Button>("CanvasLayer/HealButton");

		HurtButton.Pressed += OnHurtButtonPressed;
		HealButton.Pressed += OnHealButtonPressed;
		HealthComp.Died += OnDied;
	}

	public void OnHurtButtonPressed()
	{
		HealthComp.Hurt(10f);
		HealthLabel.Text = $"Health: {HealthComp.CurrentHealth}/{HealthComp.MaxHealth}";
		Clogger.Info($"Player hurt! Current Health: {HealthComp.CurrentHealth}");

		if (HealthComp.CurrentHealth <= 0)
		{
			OnDied();
		}
	}

	public void OnHealButtonPressed()
	{
		HealthComp.Heal(10f);
		HealthLabel.Text = $"Health: {HealthComp.CurrentHealth}/{HealthComp.MaxHealth}";
		Clogger.Info($"Player healed! Current Health: {HealthComp.CurrentHealth}");
	}

	public async void OnDied()
	{
		HurtButton.Disabled = true;
		HealButton.Disabled = true;
		// await ToSignal(GetTree().CreateTimer(0.01f), "timeout");
		HealthLabel.Text = "You Died!";
	}
}
