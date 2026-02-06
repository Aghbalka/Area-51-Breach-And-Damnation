local ServerScriptService = game:GetService("ServerScriptService")
local PlayerModule = {}

function PlayerModule.Init()
	PlayerModule.Data = {
		Inventory = {
			EquippedSurvivor = "Scout",
			EquippedVariant = "Default",
			EquippedWeapon = "Default",
			EquippedItem = "Grenade",
			EquippedKiller = "Zombie",
			EquippedKillerVariant = "Default",
			EquippedEmotes = {
				Emote1 = "Hello",
				Emote2 = "Yes",
				Emote3 = "No",
				Emote4 = "",
				Emote5 = "",
				Emote6 = "", -- VIP
				Emote7 = "", -- VIP
				Emote8 = "", -- VIP
				Emote9 = "", -- VIP
				Emote10 = "", -- VIP
			},
			Survivors = {
				["Scout"] = {
					"Default",
					"Gray",
					"Pink",
				},
			},
			Packs = {
				"Default",
				"Pink",
			},
			Weapons = {
				"M1911",
			},
			Items = {
				"Grenade",
				"Medkit",
			},
			Killers = {
				["Zombie"] = {
					"Default",
				},
			},
			KillerPacks = {
				"Default",
			},
			Emotes = {
				"Hello",
				"Yes",
				"No",
			},
			Levels = {
				Survivors = {
					["Scout"] = {
						["Experience"] = 0,
						["Level"] = 1,
						["RequiredExperience"] = 50,
					},
				},
				Killers = {
					["Zombie"] = {
						["Experience"] = 0,
						["Level"] = 1,
						["RequiredExperience"] = 50,
					},
				},
			},
		},
		GamePasses = {
			["VIP"] = false,
		},
		Currencies = {
			Money = 400,
		},
		Achievements = {
			"Welcome",
		},
		Settings = {
			Keybinds = {
				Skill1 = "Q",
				Skill2 = "E",
				Skill3 = "R",
				Skill4 = "T",
				Weapon = "V",
				Item = "B",
				Interact = "F",
			},
		},
		GameStats = {
			TimePlayed = 0,
			PrivateServerTime = 0,
			Progress = 0,
			Wins = 0,
			KillerWins = 0,
			Objectives = 0,
			Kills = 0,
			MoneySpent = 0,
		},
		MatchStats = {
			MatchTime = 0,
			SurvivalTime = 0,
			ChaseTime = 0,
			SurvivorsAlive = 0,
			KillerName = "",
		},
		Stats = {
			Status = "Spectator",
			Character = "None",
			Variant = "None",
			Level = 1,
			Experience = 0,
			RequiredExperience = 50,
			KillerChance = 1,
			Dead = false,
			InHand = "Nothing",
			Invincible = false,
			CanSprint = true,
			StaminaDraining = true,
			StaminaRegen = true,
			DamagePercent = 100,
			MaxHealth = 100,
			Health = 100,
			Sprinting = false,
			MaxStamina = 10000,
			Stamina = 10000,
			SpeedMultiplier = 1,
			Speed = 8,
			SprintSpeed = 26,
		},
		StatusEffects = {},
		Abilities = {
			SkillM1 = { ["Name"] = "", ["Cd"] = 0, ["Status"] = 1 },
			Skill1 = { ["Name"] = "", ["Cd"] = 0, ["Status"] = 1 },
			Skill2 = { ["Name"] = "", ["Cd"] = 0, ["Status"] = 1 },
			Skill3 = { ["Name"] = "", ["Cd"] = 0, ["Status"] = 1 },
			Skill4 = { ["Name"] = "", ["Cd"] = 0, ["Status"] = 1 },
			Weapon = { ["Name"] = "", ["Ammo"] = 0, ["RemainingAmmo"] = 0, Active = true },
			Item = { ["Name"] = "", ["Stock"] = 4, ["Cd"] = 0, ["Status"] = 1 },
			Passive1 = { ["Name"] = "", ["Status"] = 1 },
			Passive2 = { ["Name"] = "", ["Status"] = 1 },
		},
	}
end

function MakeFolder(Folder, Parent)
	for Name, Value in Folder do
		if typeof(Value) == "table" then
			local Folder = Instance.new("Folder")
			Folder.Name = Name
			Folder.Parent = Parent
			MakeFolder(Value, Folder)
		elseif typeof(Value) == "boolean" then
			local Bool = Instance.new("BoolValue")
			Bool.Name = Name
			Bool.Value = Value
			Bool.Parent = Parent
		elseif typeof(Value) == "number" then
			local Number = Instance.new("NumberValue")
			Number.Name = Name
			Number.Value = Value
			Number.Parent = Parent
		elseif typeof(Value) == "string" then
			local String = Instance.new("StringValue")
			String.Name = Name
			String.Value = Value
			String.Parent = Parent
		end
	end
end

local function CloneValue(value, parent)
	local clone = value:Clone()
	clone.Parent = parent
	return clone
end

local function GetOrCreatePath(root, pathParts)
	local current = root

	for i = 1, #pathParts - 1 do
		local name = pathParts[i]
		local folder = current:WaitForChild(name)

		if not folder then
			folder = Instance.new("Folder")
			folder.Name = name
			folder.Parent = current
		end

		current = folder
	end

	return current, pathParts[#pathParts]
end

local function GetRelativePath(instance, root)
	local parts = {}

	while instance and instance ~= root do
		table.insert(parts, 1, instance.Name)
		instance = instance.Parent
	end

	return parts
end

local function SyncTree(sourceRoot, targetRoot)
	local function MirrorValue(valueObject)
		local pathParts = GetRelativePath(valueObject, sourceRoot)
		local parentFolder, valueName = GetOrCreatePath(targetRoot, pathParts)

		local targetValue = parentFolder:WaitForChild(valueName)
		if not targetValue then
			targetValue = valueObject:Clone()
			targetValue.Parent = parentFolder
		end

		targetValue.Value = valueObject.Value

		valueObject.Changed:Connect(function()
			targetValue.Value = valueObject.Value
		end)
	end

	local function MirrorFolder(folder)
		if folder ~= sourceRoot then
			local pathParts = GetRelativePath(folder, sourceRoot)
			local parentFolder, folderName = GetOrCreatePath(targetRoot, pathParts)
			if not parentFolder:WaitForChild(folderName) then
				local newFolder = Instance.new("Folder")
				newFolder.Name = folderName
				newFolder.Parent = parentFolder
			end
		end

		for _, child in ipairs(folder:GetChildren()) do
			if child:IsA("Folder") then
				MirrorFolder(child)
			elseif child:IsA("ValueBase") then
				MirrorValue(child)
			end
		end

		folder.ChildAdded:Connect(function(child)
			if child:IsA("Folder") then
				MirrorFolder(child)
			elseif child:IsA("ValueBase") then
				MirrorValue(child)
			end
		end)
	end

	MirrorFolder(sourceRoot)
end

function PlayerModule.CreateData(Plr)
	local Player = require(ServerScriptService.ModuleLoader.Scripts.Player)
	local Loader = require(game.ReplicatedStorage.ModuleLoader.Loader)

	local PlayerData = Instance.new("Folder")
	PlayerData.Name = Plr.UserId
	PlayerData.Parent = Loader.Services.ServerStorage.PlayerData
	MakeFolder(PlayerModule.Data, PlayerData)

	local ReadOnlyData = Instance.new("Folder")
	ReadOnlyData.Name = "ReadOnlyData"
	ReadOnlyData.Parent = Plr
	MakeFolder(PlayerModule.Data, ReadOnlyData)

	SyncTree(PlayerData, ReadOnlyData)
end

function PlayerModule.DeleteData(Plr)
	local Loader = require(game.ReplicatedStorage.ModuleLoader.Loader)

	local PlayerData = Loader.Services.ServerStorage.PlayerData:FindFirstChild(Plr.UserId)
	if PlayerData then
		PlayerData:Destroy()
	end
end

function PlayerModule.GetData(Plr)
	local Loader = require(game.ReplicatedStorage.ModuleLoader.Loader)

	local PlayerData = Loader.Services.ServerStorage.PlayerData:WaitForChild(Plr.UserId)
	return PlayerData
end

function PlayerModule.GetReadOnlyData(Plr)
	local ReadOnlyData = Plr:WaitForChild("ReadOnlyData")
	return ReadOnlyData
end

function PlayerModule.GetValue(Plr, Path)
	local DataFolder = PlayerModule.GetData(Plr)
	if not DataFolder then
		return nil
	end

	local Current = DataFolder
	for Part in string.gmatch(Path, "[^%.]+") do
		Current = Current:WaitForChild(Part)
		if not Current then
			return nil
		end
	end

	return Current
end

function PlayerModule.SetValue(Plr, Path, NewValue)
	local ValueObject = PlayerModule.GetValue(Plr, Path)
	if ValueObject then
		ValueObject.Value = NewValue
	end
end

function PlayerModule.CreateValueObject(Plr, Path, ValueType, InitialValue)
	local DataFolder = PlayerModule.GetData(Plr)
	if not DataFolder then
		return nil
	end

	local Current = DataFolder
	local Parts = {}
	for Part in string.gmatch(Path, "[^%.]+") do
		table.insert(Parts, Part)
	end

	for i = 1, #Parts - 1 do
		local Part = Parts[i]
		local NextFolder = Current:WaitForChild(Part)
		if not NextFolder then
			NextFolder = Instance.new("Folder")
			NextFolder.Name = Part
			NextFolder.Parent = Current
		end
		Current = NextFolder
	end

	local ValueName = Parts[#Parts]
	local ValueObject = Current:WaitForChild(ValueName)
	if not ValueObject then
		ValueObject = Instance.new(ValueType)
		ValueObject.Name = ValueName
		ValueObject.Value = InitialValue
		ValueObject.Parent = Current
	end

	return ValueObject
end

function PlayerModule.GetReadOnlyValue(Plr, Path)
	local ReadOnlyData = PlayerModule.GetReadOnlyData(Plr)
	if not ReadOnlyData then
		return nil
	end

	local Current = ReadOnlyData
	for Part in string.gmatch(Path, "[^%.]+") do
		Current = Current:WaitForChild(Part)
		if not Current then
			return nil
		end
	end

	return Current
end

return PlayerModule
