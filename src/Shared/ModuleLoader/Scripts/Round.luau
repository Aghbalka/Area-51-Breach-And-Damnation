local RoundModule = {}

function RoundModule.Init()
	local Loader = require(game.ReplicatedStorage.ModuleLoader.Loader)
end

function RoundModule.ChangeRoundState(StateName)
	local RoundData = game.ServerStorage.RoundData
	local State = RoundData:FindFirstChild("State")
	if not State then
		return
	end
	State.Value = StateName
end

function RoundModule.AddTime(Amount)
	local RoundData = game.ServerStorage.RoundData
	local Time = RoundData:FindFirstChild("Time")
	if not Time then
		return
	end
	Time.Value = Time.Value + Amount
end

function RoundModule.ReduceTime(Amount)
	local RoundData = game.ServerStorage.RoundData
	local Time = RoundData:FindFirstChild("Time")
	if not Time then
		return
	end
	Time.Value = Time.Value - Amount
end

function RoundModule.SetTime(Amount)
	local RoundData = game.ServerStorage.RoundData
	local Time = RoundData:FindFirstChild("Time")
	if not Time then
		return
	end
	Time.Value = Amount
end

function RoundModule.BlockTime(ShouldBlock)
	local RoundData = game.ServerStorage.RoundData
	local Blocked = RoundData:FindFirstChild("TimeBlocked")
	if not Blocked then
		return
	end
	Blocked.Value = ShouldBlock
end

function RoundModule.EndTime()
	local RoundData = game.ServerStorage.RoundData
	local Time = RoundData:FindFirstChild("Time")
	if not Time then
		return
	end
	Time.Value = 0
end

function RoundModule.RollMap() end

function RoundModule.RollGameMode() end

function RoundModule.ChoseKiller() end

function RoundModule.SetNextKiller(PlrName) end

return RoundModule
