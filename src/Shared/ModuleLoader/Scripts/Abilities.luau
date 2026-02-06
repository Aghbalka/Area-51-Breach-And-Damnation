local AbilitiesModule = {}

AbilitiesModule.Abilities = {
	PlaceHolder = {
		Name = "PlaceHolder",
		Image = 4444,
		Description = "PlaceHolder",
		Quote = "PlaceHolder",
		Functionality = function(Plr, State)
			print("PlaceHolder User: " .. Plr.Name .. " State: " .. State)
		end,
	},
}

AbilitiesModule.Passives = {
	PlaceHolder = {
		Name = "PlaceHolder",
		Image = 4444,
		Description = "PlaceHolder",
		Quote = "PlaceHolder",
		functionality = function(Plr)
			print("PlaceHolder Got Applied to: " .. Plr.Name)
		end,
	},
}

function AbilitiesModule.UseAbility(Plr, AbilityName, State)
	local Ability = AbilitiesModule.Abilities[AbilityName]
	if Ability then
		Ability.Functionality(Plr, State)
	end
end

function AbilitiesModule.SetCooldown(Plr, Ability, CooldownTime) end

function AbilitiesModule.SetState(Plr, Ability, State) end

function AbilitiesModule.ReduceCooldown(Plr, Ability, Amount) end

return AbilitiesModule
