local rs = game:GetService(`ReplicatedStorage`)
local moduleLoader = rs:WaitForChild(`ModuleLoader`)
local loader = require(moduleLoader:WaitForChild(`Loader`))

loader.LoadAll()