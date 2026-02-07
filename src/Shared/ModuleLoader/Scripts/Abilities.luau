local EncodingService = game:GetService("EncodingService")
local ServerStorage = game:GetService("ServerStorage")
local AbilitiesModule = {}

AbilitiesModule.PlayerTracks = {}

AbilitiesModule.Abilities = {
	PlaceHolder = {
		Name = "PlaceHolder",
		Image = 4444,
		Description = "PlaceHolder",
		Quote = "PlaceHolder",
		Functionality = function(Plr, State, Keybind)
			print("PlaceHolder User: " .. Plr.Name .. " State: " .. State .. " Keybind: " .. Keybind)
			AbilitiesModule.SetCooldown(Plr, Keybind, 5)
		end,
	},
}

AbilitiesModule.Passives = {
	PlaceHolder = {
		Name = "PlaceHolder",
		Image = 4444,
		Description = "PlaceHolder",
		Quote = "PlaceHolder",
		Functionality = function(Plr, State)
			print("PlaceHolder Got Applied to: " .. Plr.Name .. " State: " .. State)
		end,
	},
}

AbilitiesModule.Items = {
	PlaceHolder = {
		Name = "PlaceHolder",
		Image = 4444,
		Description = "PlaceHolder",
		Quote = "PlaceHolder",
		Functionality = function(Plr, State)
			print("Used Item: " .. Plr.Name .. " State: " .. State)
		end,
		ModelName = "PlaceHolder",
		EquipAnim = 124594366241728,
		IdleAnim = 76119128339409,
		UnequipAnim = 119949877189803,
	},
}

AbilitiesModule.Weapons = {
	PlaceHolder = {
		Name = "PlaceHolder",
		Image = 4444,
		Description = "PlaceHolder",
		Quote = "PlaceHolder",
		ModelName = "PlaceHolder",
		EquipAnim = 117874987820333,
		IdleAnim = 88325229122129,
		UnequipAnim = 129430809420445,
	},
}

function AbilitiesModule.UseAbility(Plr, Keybind)
	local PlayerFolder = ServerStorage.PlayerData:FindFirstChild(Plr.UserId)
	local Abilities = PlayerFolder:FindFirstChild("Abilities")
	local Ability = Abilities:FindFirstChild(Keybind)
	local AbilityName = Ability:FindFirstChild("Name").Value
	if not Ability then
		print("Ability not found")
		return
	end
	local Cooldown = Ability.Cd.Value
	local Status = Ability.Status.Value
	local InHand = PlayerFolder.Stats.InHand.Value

	if InHand ~= "Nothing" then
		print("Cannot use this ability while holding " .. InHand)
		return
	end

	if Cooldown > 0 then
		print("Ability is on cooldown")
		return
	end

	local FunctionalAbility = AbilitiesModule.Abilities[AbilityName]
	if FunctionalAbility then
		FunctionalAbility.Functionality(Plr, Status, Keybind)
	end
end

function AbilitiesModule.EquipItem(Plr)
	local PlayerFolder = ServerStorage.PlayerData:FindFirstChild(Plr.UserId)
	if not PlayerFolder then
		return
	end

	local Abilities = PlayerFolder:FindFirstChild("Abilities")
	local Item = Abilities:FindFirstChild("Item")
	local ItemName = Item:FindFirstChild("Name").Value

	local Stock = Item.Stock.Value
	local Cooldown = Item.Cd.Value
	local InHand = PlayerFolder.Stats.InHand

	if InHand.Value == "Item" then
		print("Already holding an item!")
		return
	end

	if Stock <= 0 then
		print("Out of stock!")
		return
	end

	if Cooldown > 0 then
		print("Item is on cooldown!")
		return
	end

	local FunctionalItem = AbilitiesModule.Items[ItemName]
	if not FunctionalItem then
		print("Item not found in module!")
		return
	end

	local ItemModel = game.ReplicatedStorage.Assets.Items:FindFirstChild(FunctionalItem.ModelName)
	if not ItemModel then
		print("Item model missing: " .. FunctionalItem.ModelName)
		return
	end

	local ClonedItem = ItemModel:Clone()
	ClonedItem.Parent = Plr.Character
	ClonedItem.Name = "EquippedItem"

	local RightArm = Plr.Character:FindFirstChild("Right Arm") or Plr.Character:FindFirstChild("RightHand")
	if not RightArm then
		print("Right arm not found!")
		return
	end

	local Motor6D = Instance.new("Motor6D")
	Motor6D.Name = "ItemWeld"
	Motor6D.Part0 = RightArm
	Motor6D.Part1 = ClonedItem
	Motor6D.Parent = ClonedItem

	InHand.Value = "Item"

	local Humanoid = Plr.Character:FindFirstChildOfClass("Humanoid")

	local EquipAnim = Instance.new("Animation")
	EquipAnim.AnimationId = "rbxassetid://" .. FunctionalItem.EquipAnim
	local IdleAnim = Instance.new("Animation")
	IdleAnim.AnimationId = "rbxassetid://" .. FunctionalItem.IdleAnim

	local EquipTrack = Humanoid:LoadAnimation(EquipAnim)
	local IdleTrack = Humanoid:LoadAnimation(IdleAnim)
	EquipTrack.Priority = Enum.AnimationPriority.Action
	IdleTrack.Priority = Enum.AnimationPriority.Action2

	AbilitiesModule.PlayerTracks[Plr.UserId] = {
		IdleTrack = IdleTrack,
		EquipTrack = EquipTrack,
	}

	for _, track in pairs(Humanoid:GetPlayingAnimationTracks()) do
		track:Stop()
	end

	EquipTrack:Play()
	EquipTrack.Stopped:Connect(function()
		IdleTrack:Play()
	end)
end

function AbilitiesModule.UnequipItem(Plr)
	local PlayerFolder = ServerStorage.PlayerData:FindFirstChild(Plr.UserId)
	if not PlayerFolder then
		return
	end

	local Abilities = PlayerFolder:FindFirstChild("Abilities")
	local Item = Abilities:FindFirstChild("Item")
	local ItemName = Item:FindFirstChild("Name").Value

	local InHand = PlayerFolder.Stats.InHand
	if InHand.Value ~= "Item" then
		print("Player not holding an item!")
		return
	end

	InHand.Value = "Nothing"

	local tracks = AbilitiesModule.PlayerTracks[Plr.UserId]

	local FunctionalItem = AbilitiesModule.Items[ItemName]
	local Humanoid = Plr.Character:FindFirstChildOfClass("Humanoid")

	if tracks and tracks.IdleTrack then
		tracks.IdleTrack:Stop()
	end

	local UnequipAnim = Instance.new("Animation")
	UnequipAnim.AnimationId = "rbxassetid://" .. FunctionalItem.UnequipAnim
	local UnequipTrack = Humanoid:LoadAnimation(UnequipAnim)
	UnequipTrack.Priority = Enum.AnimationPriority.Action

	for _, track in pairs(Humanoid:GetPlayingAnimationTracks()) do
		track:Stop()
	end

	UnequipTrack:Play()
	UnequipTrack.Stopped:Wait()

	AbilitiesModule.PlayerTracks[Plr.UserId] = nil
	local EquippedItem = Plr.Character:FindFirstChild("EquippedItem")
	if EquippedItem then
		EquippedItem:Destroy()
	end
end

function AbilitiesModule.UseItem(Plr)
	local PlayerFolder = ServerStorage.PlayerData:FindFirstChild(Plr.UserId)
	local Abilities = PlayerFolder:FindFirstChild("Abilities")
	local Item = Abilities:FindFirstChild("Item")
	local ItemName = Item:FindFirstChild("Name").Value

	local Status = Item.Status.Value
	local Stock = Item.Stock.Value

	local FunctionalItem = AbilitiesModule.Items[ItemName]
	if FunctionalItem then
		FunctionalItem.Functionality(Plr, Status)
		Item.Stock.Value = Stock - 1
	end
end

function AbilitiesModule.EquipWeapon(Plr)
	local PlayerFolder = ServerStorage.PlayerData:FindFirstChild(Plr.UserId)
	local Abilities = PlayerFolder:FindFirstChild("Abilities")
	local Weapon = Abilities:FindFirstChild("Weapon")
	local WeaponName = Weapon:FindFirstChild("Name").Value

	local InHand = PlayerFolder.Stats.InHand

	if InHand.Value == "Weapon" then
		return
	end

	local FunctionalWeapon = AbilitiesModule.Weapons[WeaponName]
	local WeaponModel = game.ReplicatedStorage.Assets.Weapons:FindFirstChild(FunctionalWeapon.ModelName)
	local ClonedItem = WeaponModel:Clone()
	ClonedItem.Parent = Plr.Character
	ClonedItem.Name = "EquippedWeapon"
	local Motor6D = Instance.new("Motor6D")
	Motor6D.Name = "WeaponWeld"
	Motor6D.Part0 = Plr.Character:FindFirstChild("Right Arm")
	Motor6D.Part1 = ClonedItem
	Motor6D.Parent = ClonedItem

	InHand.Value = "Weapon"

	local Humanoid = Plr.Character:FindFirstChildOfClass("Humanoid")
	if not Humanoid then
		print("Humanoid not found!")
		return
	end

	local EquipAnim = Instance.new("Animation")
	EquipAnim.AnimationId = "rbxassetid://" .. FunctionalWeapon.EquipAnim
	local IdleAnim = Instance.new("Animation")
	IdleAnim.AnimationId = "rbxassetid://" .. FunctionalWeapon.IdleAnim

	local EquipTrack = Humanoid:LoadAnimation(EquipAnim)
	local IdleTrack = Humanoid:LoadAnimation(IdleAnim)
	EquipTrack.Priority = Enum.AnimationPriority.Action
	IdleTrack.Priority = Enum.AnimationPriority.Action2

	AbilitiesModule.PlayerTracks[Plr.UserId] = {
		IdleTrack = IdleTrack,
		EquipTrack = EquipTrack,
	}

	for _, track in pairs(Humanoid:GetPlayingAnimationTracks()) do
		track:Stop()
	end

	EquipTrack:Play()
	EquipTrack.Stopped:Connect(function()
		IdleTrack:Play()
	end)

	print("Equipped Weapon!")
end

function AbilitiesModule.UnequipWeapon(Plr)
	local PlayerFolder = ServerStorage.PlayerData:FindFirstChild(Plr.UserId)
	local Abilities = PlayerFolder:FindFirstChild("Abilities")
	local Weapon = Abilities:FindFirstChild("Weapon")
	local WeaponName = Weapon:FindFirstChild("Name").Value

	local InHand = game.ServerStorage.PlayerData:FindFirstChild(Plr.UserId).Stats.InHand
	if InHand.Value ~= "Weapon" then
		return
	end

	local EquippedWeapon = Plr.Character:FindFirstChild("EquippedWeapon")
	if EquippedWeapon then
		EquippedWeapon:Destroy()
	end

	InHand.Value = "Nothing"
	print("Unequipped Weapon!")

	local tracks = AbilitiesModule.PlayerTracks[Plr.UserId]

	local FunctionalItem = AbilitiesModule.Items[WeaponName]
	local Humanoid = Plr.Character:FindFirstChildOfClass("Humanoid")

	if tracks and tracks.IdleTrack then
		tracks.IdleTrack:Stop()
	end

	local UnequipAnim = Instance.new("Animation")
	UnequipAnim.AnimationId = "rbxassetid://" .. FunctionalItem.UnequipAnim
	local UnequipTrack = Humanoid:LoadAnimation(UnequipAnim)
	UnequipTrack.Priority = Enum.AnimationPriority.Action

	for _, track in pairs(Humanoid:GetPlayingAnimationTracks()) do
		track:Stop()
	end

	UnequipTrack:Play()
	UnequipTrack.Stopped:Wait()

	AbilitiesModule.PlayerTracks[Plr.UserId] = nil
	local EquippedItem = Plr.Character:FindFirstChild("EquippedItem")
	if EquippedItem then
		EquippedItem:Destroy()
	end
end

function AbilitiesModule.SetCooldown(Plr, Keybind, CooldownTime)
	local PlayerFolder = ServerStorage.PlayerData:FindFirstChild(Plr.UserId)

	if PlayerFolder:FindFirstChild("Stats"):FindFirstChild("AbilityCooldowns").Value == false then
		return
	end

	local Abilities = PlayerFolder:FindFirstChild("Abilities")
	local Ability = Abilities:FindFirstChild(Keybind)
	if Ability then
		Ability.Cd.Value = CooldownTime
	end

	while wait(1) do
		if Ability.Cd.Value <= 0 then
			Ability.Cd.Value = 0
			break
		end
		Ability.Cd.Value = Ability.Cd.Value - 1
	end
end

function AbilitiesModule.SetStatus(Plr, Keybind, Status)
	local PlayerFolder = ServerStorage.PlayerData:FindFirstChild(Plr.UserId)
	local Abilities = PlayerFolder:FindFirstChild("Abilities")
	local Ability = Abilities:FindFirstChild(Keybind)
	if Ability then
		Ability.Status.Value = Status
	end
end

function AbilitiesModule.ReduceCooldown(Plr, Keybind, Amount)
	local PlayerFolder = ServerStorage.PlayerData:FindFirstChild(Plr.UserId)
	local Abilities = PlayerFolder:FindFirstChild("Abilities")
	local Ability = Abilities:FindFirstChild(Keybind)
	if Ability then
		Ability.Cd.Value = math.max(0, Ability.Cd.Value - Amount)
	end
end

return AbilitiesModule
