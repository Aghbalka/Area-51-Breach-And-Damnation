local EffectsModule = {}

EffectsModule.Effects = {
	PlaceHolder = {
		Name = "PlaceHolder",
		Image = 4444,
		Description = "PlaceHolder",
		Functionalities = {
			Start = function(Plr, Source)
				print("PlaceHolder Effect Started on: " .. Plr.Name .. " from Source: " .. Source.Name)
			end,
			Second = function(Plr, Source)
				print("PlaceHolder Effect Second Passed on: " .. Plr.Name .. " from Source: " .. Source.Name)
			end,
			End = function(Plr, Source)
				print("PlaceHolder Effect Ended on: " .. Plr.Name .. " from Source: " .. Source.Name)
			end,
		},
	},
}

function EffectsModule.ApplyEffect(Plr, EffectName, Dur, Source)
	local ServerStorage = game:GetService("ServerStorage")
	local StatusEffects = ServerStorage.PlayerData:FindFirstChild(Plr.UserId):FindFirstChild("StatusEffects")
	local Effect = Instance.new("Folder")
	Effect.Name = EffectName
	Effect.Parent = StatusEffects
	local Duration = Instance.new("IntValue")
	Duration.Name = "Duration"
	Duration.Parent = Effect
	Duration.Value = Dur
end

function EffectsModule.RemoveEffect(Plr, EffectName)
	local ServerStorage = game:GetService("ServerStorage")
	local StatusEffects = ServerStorage.PlayerData:FindFirstChild(Plr.UserId):FindFirstChild("StatusEffects")
	local Effect = StatusEffects:FindFirstChild(EffectName)
	if Effect then
		Effect:Destroy()
	end
end

function EffectsModule.HasEffect(Plr, EffectName)
	local ServerStorage = game:GetService("ServerStorage")
	local StatusEffects = ServerStorage.PlayerData:FindFirstChild(Plr.UserId):FindFirstChild("StatusEffects")
	local Effect = StatusEffects:FindFirstChild(EffectName)
	if Effect then
		return true
	end
end

return EffectsModule
