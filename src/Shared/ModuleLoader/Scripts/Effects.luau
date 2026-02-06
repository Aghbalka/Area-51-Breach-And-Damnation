local EffectsModule = {}

EffectsModule.Effects = {
	PlaceHolder = {
		Name = "PlaceHolder",
		Image = 4444,
		Description = "PlaceHolder",
		Functionalities = {
			Start = function(Plr)
				print("PlaceHolder Effect Started on: " .. Plr.Name)
			end,
			Second = function(Plr)
				print("PlaceHolder Effect Second Passed on: " .. Plr.Name)
			end,
			End = function(Plr)
				print("PlaceHolder Effect Ended on: " .. Plr.Name)
			end,
		},
	},
}

function EffectsModule.ApplyEffect(Plr, EffectName) end

function EffectsModule.RemoveEffect(Plr, EffectName) end

function EffectsModule.HasEffect(Plr, EffectName) end

return EffectsModule
