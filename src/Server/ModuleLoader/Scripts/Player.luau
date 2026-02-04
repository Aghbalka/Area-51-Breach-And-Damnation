local PlayerServer = {}

function PlayerServer.Start()
	
	local Loader = require(game.ReplicatedStorage.ModuleLoader.Loader)
	local PlayerData = Loader.RequireSharedModule("PlayerData")
	local ServerStorage = Loader.Services.ServerStorage

	local Players = Loader.Services.Players
	Players.PlayerAdded:Connect(function(player)
		PlayerData.CreateData(player)
	end)
end

return PlayerServer