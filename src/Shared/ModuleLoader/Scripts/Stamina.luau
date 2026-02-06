local StaminaModule = {}

function StaminaModule.SetSprintState(Plr, IsSprinting)
	local PlayerModule = require(game.ReplicatedStorage.ModuleLoader.Scripts.Player)
	local Sprinting = PlayerModule.GetValue(Plr, "Stats.Sprinting")
	if Sprinting then
		Sprinting.Value = IsSprinting
	end

	local Walkspeed = PlayerModule.GetValue(Plr, "Stats.Speed")
	local SprintSpeed = PlayerModule.GetValue(Plr, "Stats.SprintSpeed")

	if IsSprinting then
		Plr.Character.Humanoid.WalkSpeed = SprintSpeed.Value
	else
		Plr.Character.Humanoid.WalkSpeed = Walkspeed.Value
	end
end

function StaminaModule.AddStamina(Plr, Amount)
	local PlayerModule = require(game.ReplicatedStorage.ModuleLoader.Scripts.Player)
	local Stamina = PlayerModule.GetValue(Plr, "Stats.Stamina")
	local MaxStamina = PlayerModule.GetValue(Plr, "Stats.MaxStamina")
	if Stamina then
		Stamina.Value = math.min(Stamina.Value + Amount, MaxStamina.Value)
	end
end

function StaminaModule.RemoveStamina(Plr, Amount)
	local PlayerModule = require(game.ReplicatedStorage.ModuleLoader.Scripts.Player)
	local Stamina = PlayerModule.GetValue(Plr, "Stats.Stamina")
	local MaxStamina = PlayerModule.GetValue(Plr, "Stats.MaxStamina")
	if Stamina then
		Stamina.Value = math.max(Stamina.Value - Amount, 0)
	end
end

function StaminaModule.SetStamina(Plr, Amount)
	local PlayerModule = require(game.ReplicatedStorage.ModuleLoader.Scripts.Player)
	local Stamina = PlayerModule.GetValue(Plr, "Stats.Stamina")
	local MaxStamina = PlayerModule.GetValue(Plr, "Stats.MaxStamina")
	if Stamina then
		Stamina.Value = math.clamp(Amount, 0, MaxStamina.Value)
	end
end

function StaminaModule.BlockStaminaRegen(Plr, ShouldBlock)
	local PlayerModule = require(game.ReplicatedStorage.ModuleLoader.Scripts.Player)
	local BlockRegen = PlayerModule.GetValue(Plr, "Stats.StaminaRegen")
	if BlockRegen then
		BlockRegen.Value = ShouldBlock
	end
end

function StaminaModule.BlockStaminaDrain(Plr, ShouldBlock)
	local PlayerModule = require(game.ReplicatedStorage.ModuleLoader.Scripts.Player)
	local BlockDrain = PlayerModule.GetValue(Plr, "Stats.StaminaDraining")
	if BlockDrain then
		BlockDrain.Value = ShouldBlock
	end
end

function StaminaModule.BlockStaminaUse(Plr, ShouldBlock)
	local PlayerModule = require(game.ReplicatedStorage.ModuleLoader.Scripts.Player)
	local BlockUse = PlayerModule.GetValue(Plr, "Stats.CanSprint")
	if BlockUse then
		BlockUse.Value = ShouldBlock
	end
end

return StaminaModule
