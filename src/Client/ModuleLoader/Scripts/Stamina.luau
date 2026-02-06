local StaminaLocal = {}

function StaminaLocal.Start()
	local Loader = require(game.ReplicatedStorage.ModuleLoader.Loader)
	local PlayerModule = require(game.ReplicatedStorage.ModuleLoader.Scripts.Player)
	local Player = Loader.Services.Players.LocalPlayer
	local UIS = game:GetService("UserInputService")

	local StaminaEvent = Loader.Services.ReplicatedStorage.ModuleLoader.Scripts.Stamina:WaitForChild("StaminaEvent")

	UIS.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		if input.KeyCode == Enum.KeyCode.LeftShift then
			StaminaEvent:FireServer("StartSprinting")
		end
	end)

	UIS.InputEnded:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		if input.KeyCode == Enum.KeyCode.LeftShift then
			StaminaEvent:FireServer("StopSprinting")
		end
	end)
end

return StaminaLocal
