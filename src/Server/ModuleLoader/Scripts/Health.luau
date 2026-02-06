local HealthServer = {}

function HealthServer.Start()
	local Loader = require(game.ReplicatedStorage.ModuleLoader.Loader)
	local Players = Loader.Services.Players
	local PlayerModule = require(game.ReplicatedStorage.ModuleLoader.Scripts.Player)

	local function CheckForHealth(Health, Plr)
		if Health <= 0 then
			print("Player is dead!")
		elseif Health > 0 and Health < 25 then
			print("Player is low!")
		elseif Health >= 25 and Health < 50 then
			print("Player is hurt!")
		elseif Health >= 50 and Health < 100 then
			print("Player is alive!")
		end
	end

	for _, plr in ipairs(Players:GetPlayers()) do
		local Health = PlayerModule.GetValue(plr, "Stats.Health")
		Health:GetPropertyChangedSignal("Value"):Connect(function()
			local NewVal = Health.Value
			CheckForHealth(NewVal, plr)
		end)
	end

	Players.PlayerAdded:Connect(function(plr)
		local Health = PlayerModule.GetValue(plr, "Stats.Health")
		Health:GetPropertyChangedSignal("Value"):Connect(function()
			local NewVal = Health.Value
			CheckForHealth(NewVal, plr)
		end)
	end)
end

return HealthServer
