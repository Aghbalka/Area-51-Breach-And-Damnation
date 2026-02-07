local EffectsServer = {}

function EffectsServer.Start()
	local EffectsModule = require(game.ReplicatedStorage.ModuleLoader.Scripts.Effects)
	local Players = game:GetService("Players")

	function CheckForEffects(Plr)
		local ServerStorage = game:GetService("ServerStorage")
		local StatusEffects = ServerStorage.PlayerData:FindFirstChild(Plr.UserId):WaitForChild("StatusEffects")
		StatusEffects.ChildAdded:Connect(function(Effect)
			local EffectInfo = EffectsModule.Effects[Effect.Name]
			if EffectInfo and EffectInfo.Functionalities and EffectInfo.Functionalities.Start then
				EffectInfo.Functionalities.Start(Plr, game.ReplicatedStorage)
			end
			for i = 1, Effect.Duration.Value do
				wait(1)
				if EffectInfo and EffectInfo.Functionalities and EffectInfo.Functionalities.Second then
					EffectInfo.Functionalities.Second(Plr, game.ReplicatedStorage)
				end
				Effect.Duration.Value = Effect.Duration.Value - 1
			end
			if EffectInfo and EffectInfo.Functionalities and EffectInfo.Functionalities.End then
				EffectInfo.Functionalities.End(Plr, game.ReplicatedStorage)
			end
			Effect:Destroy()
			Plr.ReadOnlyData.StatusEffects:FindFirstChild(Effect.Name):Destroy()
		end)
	end

	for _, Plr in pairs(Players:GetPlayers()) do
		CheckForEffects(Plr)
	end

	game.Players.PlayerAdded:Connect(function(Plr)
		CheckForEffects(Plr)
	end)
end

return EffectsServer
