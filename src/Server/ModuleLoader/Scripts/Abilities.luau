local AbilitiesServer = {}

function AbilitiesServer.Start()
	local AbilitiesModule = require(game.ReplicatedStorage.ModuleLoader.Scripts.Abilities)
	local UseSkillEvent = Instance.new("RemoteEvent")
	UseSkillEvent.Name = "UseSkillEvent"
	UseSkillEvent.Parent = game.ReplicatedStorage.ModuleLoader.Scripts.Abilities
	local EquipItemEvent = Instance.new("RemoteEvent")
	EquipItemEvent.Name = "EquipItemEvent"
	EquipItemEvent.Parent = game.ReplicatedStorage.ModuleLoader.Scripts.Abilities
	local EquipWeaponEvent = Instance.new("RemoteEvent")
	EquipWeaponEvent.Name = "EquipWeaponEvent"
	EquipWeaponEvent.Parent = game.ReplicatedStorage.ModuleLoader.Scripts.Abilities
	local M1Event = Instance.new("RemoteEvent")
	M1Event.Name = "M1Event"
	M1Event.Parent = game.ReplicatedStorage.ModuleLoader.Scripts.Abilities

	UseSkillEvent.OnServerEvent:Connect(function(Plr, Keybind)
		AbilitiesModule.UseAbility(Plr, Keybind)
	end)

	EquipItemEvent.OnServerEvent:Connect(function(Plr)
		local PlayerFolder = game:GetService("ServerStorage").PlayerData:FindFirstChild(Plr.UserId)
		local InHand = PlayerFolder.Stats.InHand.Value
		if InHand == "Item" then
			AbilitiesModule.UnequipItem(Plr)
		elseif InHand == "Nothing" then
			AbilitiesModule.EquipItem(Plr)
		end
	end)

	EquipWeaponEvent.OnServerEvent:Connect(function(Plr)
		local PlayerFolder = game:GetService("ServerStorage").PlayerData:FindFirstChild(Plr.UserId)
		local InHand = PlayerFolder.Stats.InHand.Value
		if InHand == "Weapon" then
			AbilitiesModule.UnequipWeapon(Plr)
		elseif InHand == "Nothing" then
			AbilitiesModule.EquipWeapon(Plr)
		end
	end)

	M1Event.OnServerEvent:Connect(function(Plr)
		local PlayerFolder = game:GetService("ServerStorage").PlayerData:FindFirstChild(Plr.UserId)
		local InHand = PlayerFolder.Stats.InHand.Value
		if InHand == "Item" then
			print("Used Item M1!")
		elseif InHand == "Weapon" then
			print("Used Weapon M1!")
		elseif InHand == "Nothing" then
			AbilitiesModule.UseAbility(Plr, "SkillM1")
		end
	end)
end

return AbilitiesServer
