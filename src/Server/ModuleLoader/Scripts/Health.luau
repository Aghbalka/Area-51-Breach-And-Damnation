local HealthServer = {}

function HealthServer.Start()
	local Loader = require(game.ReplicatedStorage.ModuleLoader.Loader)
	local Players = Loader.Services.Players
	local PlayerModule = require(game.ReplicatedStorage.ModuleLoader.Scripts.Player)

	for _, plr in ipairs(Players:GetPlayers()) do
		local Health = PlayerModule.GetValue(plr, "Stats.Health")
		Health:GetPropertyChangedSignal("Value"):Connect(function()
			print(Health.Value)
		end)
	end

	Players.PlayerAdded:Connect(function(plr)
		local Health = PlayerModule.GetValue(plr, "Stats.Health")
		Health:GetPropertyChangedSignal("Value"):Connect(function()
			print(Health.Value)
		end)
	end)

end

return HealthServer