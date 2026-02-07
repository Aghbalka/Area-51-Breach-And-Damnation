local StaminaServer = {}

function StaminaServer.Start()
	local Loader = require(game.ReplicatedStorage.ModuleLoader.Loader)
	local Players = Loader.Services.Players
	local PlayerModule = require(game.ReplicatedStorage.ModuleLoader.Scripts.Player)
	local StaminaModule = require(game.ReplicatedStorage.ModuleLoader.Scripts.Stamina)
	local RunService = game:GetService("RunService")

	local staminaFolder = Loader.Services.ReplicatedStorage.ModuleLoader.Scripts.Stamina
	local StaminaEvent = staminaFolder:FindFirstChild("StaminaEvent")

	if not StaminaEvent then
		StaminaEvent = Instance.new("RemoteEvent")
		StaminaEvent.Name = "StaminaEvent"
		StaminaEvent.Parent = staminaFolder
	end

	local function ApplySpeed(plr)
		local char = plr.Character
		if not char then
			return
		end

		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hum then
			return
		end

		local walkSpeed = PlayerModule.GetValue(plr, "Stats.Speed")
		local sprintSpeed = PlayerModule.GetValue(plr, "Stats.SprintSpeed")
		local isSprinting = PlayerModule.GetValue(plr, "Stats.Sprinting")
		local speedMultiplier = PlayerModule.GetValue(plr, "Stats.SpeedMultiplier")

		if not (walkSpeed and sprintSpeed and isSprinting and speedMultiplier) then
			return
		end

		local baseSpeed = isSprinting.Value and sprintSpeed.Value or walkSpeed.Value
		hum.WalkSpeed = baseSpeed * speedMultiplier.Value
	end

	local function HookSpeedMultiplier(plr)
		local speedMultiplier = PlayerModule.GetValue(plr, "Stats.SpeedMultiplier")
		if not speedMultiplier then
			return
		end

		speedMultiplier:GetPropertyChangedSignal("Value"):Connect(function()
			ApplySpeed(plr)
		end)
	end

	for _, plr in ipairs(Players:GetPlayers()) do
		HookSpeedMultiplier(plr)
	end
	Players.PlayerAdded:Connect(HookSpeedMultiplier)

	StaminaEvent.OnServerEvent:Connect(function(plr, action)
		local canSprint = PlayerModule.GetValue(plr, "Stats.CanSprint")
		if not canSprint then
			return
		end

		if action == "StartSprinting" and canSprint.Value then
			StaminaModule.SetSprintState(plr, true)
			ApplySpeed(plr)
		elseif action == "StopSprinting" then
			StaminaModule.SetSprintState(plr, false)
			ApplySpeed(plr)
		end
	end)

	local lastSprintTime = {}
	local exhaustedUntil = {}

	RunService.Heartbeat:Connect(function(dt)
		for _, plr in ipairs(Players:GetPlayers()) do
			local stamina = PlayerModule.GetValue(plr, "Stats.Stamina")
			local maxStamina = PlayerModule.GetValue(plr, "Stats.MaxStamina")
			local isSprinting = PlayerModule.GetValue(plr, "Stats.Sprinting")
			local canSprint = PlayerModule.GetValue(plr, "Stats.CanSprint")
			local canDrain = PlayerModule.GetValue(plr, "Stats.StaminaDraining")
			local canRegen = PlayerModule.GetValue(plr, "Stats.StaminaRegen")

			local drainRate = PlayerModule.GetValue(plr, "Stats.StaminaDrainPerSec")
			local regenRate = PlayerModule.GetValue(plr, "Stats.StaminaRegenPerSec")
			local delay = PlayerModule.GetValue(plr, "Stats.StaminaDelay")
			local exhaustionDelay = PlayerModule.GetValue(plr, "Stats.ExhaustionDelay")

			if not (stamina and maxStamina and isSprinting and canSprint) then
				continue
			end

			lastSprintTime[plr] = lastSprintTime[plr] or 0
			exhaustedUntil[plr] = exhaustedUntil[plr] or 0

			if os.clock() < exhaustedUntil[plr] then
				canSprint.Value = false
				continue
			end

			canSprint.Value = true

			if isSprinting.Value then
				lastSprintTime[plr] = os.clock()
			end

			if isSprinting.Value and (not canDrain or canDrain.Value) then
				stamina.Value = math.max(stamina.Value - (drainRate.Value * dt), 0)

				if stamina.Value <= 0 then
					stamina.Value = 0
					canSprint.Value = false
					exhaustedUntil[plr] = os.clock() + exhaustionDelay.Value
					StaminaModule.SetSprintState(plr, false)
					ApplySpeed(plr)
				end
			elseif
				not isSprinting.Value
				and (os.clock() - lastSprintTime[plr] >= delay.Value)
				and (not canRegen or canRegen.Value)
			then
				stamina.Value = math.min(stamina.Value + (regenRate.Value * dt), maxStamina.Value)
			end
		end
	end)
end

return StaminaServer
