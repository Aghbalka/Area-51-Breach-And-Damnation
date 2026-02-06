local HealthModule = {}

function HealthModule.Init()
	local Loader = require(game.ReplicatedStorage.ModuleLoader.Loader)
end

function HealthModule.DamagePlayer(Plr, Amount)
	local PlayerModule = require(game.ReplicatedStorage.ModuleLoader.Scripts.Player)
	local Health = PlayerModule.GetValue(Plr, "Stats.Health")
	if Health then
		Health.Value = math.max(Health.Value - Amount, 0)
	end
end

function HealthModule.HealPlayer(Plr, Amount)
	local PlayerModule = require(game.ReplicatedStorage.ModuleLoader.Scripts.Player)
	local Health = PlayerModule.GetValue(Plr, "Stats.Health")
	local MaxHealth = PlayerModule.GetValue(Plr, "Stats.MaxHealth")
	if Health then
		Health.Value = math.min(Health.Value + Amount, MaxHealth.Value)
	end
end

function HealthModule.SetPlayerHealth(Plr, Amount)
	local PlayerModule = require(game.ReplicatedStorage.ModuleLoader.Scripts.Player)
	local Health = PlayerModule.GetValue(Plr, "Stats.Health")
	local MaxHealth = PlayerModule.GetValue(Plr, "Stats.MaxHealth")
	if Health then
		Health.Value = math.clamp(Amount, 0, MaxHealth.Value)
	end
end

function HealthModule.KillPlayer(Plr)
	local PlayerModule = require(game.ReplicatedStorage.ModuleLoader.Scripts.Player)
	local Health = PlayerModule.GetValue(Plr, "Stats.Health")
	if Health then
		Health.Value = 0
	end
end

return HealthModule
