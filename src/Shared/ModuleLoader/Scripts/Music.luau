local MusicModule = {}

MusicModule.MusicTracks = {
	Chase = {
		Killer1 = "rbxassetid://1234567890",
		Killer2 = "rbxassetid://7777777777",
	},
	Map = {
		Map1 = "rbxassetid://1111111111",
		Map2 = "rbxassetid://2222222222",
	},
	Ambience = {
		Map1 = "rbxassetid://1111111111",
		Map2 = "rbxassetid://2222222222",
	},
	PlanB = {
		Default = "rbxassetid://3333333333",
	},
}

function MusicModule.PlayChaseMusic(Plr, KillerName) end

function MusicModule.PlayMapMusic(Plr, MapName) end

function MusicModule.PlayPlanBMusic(Plr, PlanBName) end

function MusicModule.RemoveAllMusic(Plr) end

function MusicModule.RemoveChaseMusic(Plr, KillerName) end

function MusicModule.RemoveMapMusic(Plr, MapName) end

function MusicModule.RemovePlanBMusic(Plr, PlanBName) end

return MusicModule
