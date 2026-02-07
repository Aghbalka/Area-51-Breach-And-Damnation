local AbilitiesClient = {}

function AbilitiesClient.Start()
	local UIS = game:GetService("UserInputService")
	local Player = game.Players.LocalPlayer

	local Keybinds = {
		Skill1 = Enum.KeyCode[Player:WaitForChild("ReadOnlyData")
			:WaitForChild("Settings")
			:WaitForChild("Keybinds")
			:WaitForChild("Skill1").Value],
		Skill2 = Enum.KeyCode[Player:WaitForChild("ReadOnlyData")
			:WaitForChild("Settings")
			:WaitForChild("Keybinds")
			:WaitForChild("Skill2").Value],
		Skill3 = Enum.KeyCode[Player:WaitForChild("ReadOnlyData")
			:WaitForChild("Settings")
			:WaitForChild("Keybinds")
			:WaitForChild("Skill3").Value],
		Skill4 = Enum.KeyCode[Player:WaitForChild("ReadOnlyData")
			:WaitForChild("Settings")
			:WaitForChild("Keybinds")
			:WaitForChild("Skill4").Value],
	}

	local ItemKeybind = Enum.KeyCode[Player:WaitForChild("ReadOnlyData")
		:WaitForChild("Settings")
		:WaitForChild("Keybinds")
		:WaitForChild("Item").Value]
	local WeaponKeybind = Enum.KeyCode[Player:WaitForChild("ReadOnlyData")
		:WaitForChild("Settings")
		:WaitForChild("Keybinds")
		:WaitForChild("Weapon").Value]

	print("Works")

	local M1Event = game.ReplicatedStorage.ModuleLoader.Scripts.Abilities:WaitForChild("M1Event")
	local UseSkillEvent = game.ReplicatedStorage.ModuleLoader.Scripts.Abilities:WaitForChild("UseSkillEvent")
	local EquipItemEvent = game.ReplicatedStorage.ModuleLoader.Scripts.Abilities:WaitForChild("EquipItemEvent")
	local EquipWeaponEvent = game.ReplicatedStorage.ModuleLoader.Scripts.Abilities:WaitForChild("EquipWeaponEvent")

	print("Works")

	UIS.InputBegan:Connect(function(Input, GameProcessed)
		if GameProcessed then
			return
		end

		for SkillName, Keybind in pairs(Keybinds) do
			if Input.KeyCode == Keybind then
				UseSkillEvent:FireServer(SkillName)
				return
			end
		end
	end)

	UIS.InputBegan:Connect(function(Input, GameProcessed)
		if GameProcessed then
			return
		end
		if Input.KeyCode == ItemKeybind then
			EquipItemEvent:FireServer()
		elseif Input.KeyCode == WeaponKeybind then
			EquipWeaponEvent:FireServer()
		end
	end)

	UIS.InputBegan:Connect(function(Input, GameProcessed)
		if GameProcessed then
			return
		end
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then
			M1Event:FireServer()
		end
	end)
end

return AbilitiesClient
