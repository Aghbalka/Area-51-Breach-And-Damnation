local loader = {}
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

loader.Services = {
	UserInputService = game:GetService("UserInputService"),
	Players = game:GetService("Players"),
	ReplicatedStorage = ReplicatedStorage,
	ServerScriptService = ServerScriptService,
	ReplicatedFirst = ReplicatedFirst,
	RunService = RunService,
	Workspace = game:GetService("Workspace"),
	Lighting = game:GetService("Lighting"),
	TweenService = game:GetService("TweenService"),
	ServerStorage = game:GetService("ServerStorage")
}

-- Cache
local sharedScripts, serverScripts, localScripts
local cache = {}

-- Get RemoteEvent for shared module
function loader.GetEvent(moduleName)
	sharedScripts = sharedScripts or ReplicatedStorage:WaitForChild("ModuleLoader"):WaitForChild("Scripts")
	local moduleScript = sharedScripts:FindFirstChild(moduleName)
	if not moduleScript or not moduleScript:IsA("ModuleScript") then
		error("Shared module '" .. moduleName .. "' not found!")
	end

	local event = moduleScript:FindFirstChild("Event")
	if not event then
		event = Instance.new("RemoteEvent")
		event.Name = "Event"
		event.Parent = moduleScript
	end

	return event
end

-- Require shared module
function loader.RequireSharedModule(name)
	sharedScripts = sharedScripts or ReplicatedStorage:WaitForChild("ModuleLoader"):WaitForChild("Scripts")

	local module = require(sharedScripts:WaitForChild(name))
	module.Services = loader.Services
	cache[name] = module

	if module.Init then pcall(module.Init, module) end
	if module.Start then pcall(module.Start, module) end

	return module
end

-- Require server-only module
function loader.RequireServerModule(name)
	if not RunService:IsServer() then
		error("RequireServerModule can only be used on the server!")
	end

	serverScripts = serverScripts or ServerScriptService:WaitForChild("ModuleLoader"):WaitForChild("Scripts")

	local module = require(serverScripts:WaitForChild(name))
	module.Services = loader.Services
	cache[name] = module

	if module.Init then pcall(module.Init, module) end
	if module.Start then pcall(module.Start, module) end

	return module
end

-- Require client-only module
function loader.RequireLocalModule(name)
	if not RunService:IsClient() then
		error("RequireLocalModule can only be used on the client!")
	end

	localScripts = localScripts or ReplicatedFirst:WaitForChild("ModuleLoader"):WaitForChild("Scripts")

	local module = require(localScripts:WaitForChild(name))
	module.Services = loader.Services
	cache[name] = module

	if module.Init then pcall(module.Init, module) end
	if module.Start then pcall(module.Start, module) end

	return module
end

-- Load all modules for current environment
function loader.LoadAll()
	-- 🔹 Shared modules
	sharedScripts = sharedScripts or ReplicatedStorage:WaitForChild("ModuleLoader"):WaitForChild("Scripts")

	for _, moduleScript in ipairs(sharedScripts:GetChildren()) do
		if moduleScript:IsA("ModuleScript") then
			local ok, module = pcall(require, moduleScript)
			if ok then
				module.Services = loader.Services
				cache[moduleScript.Name] = module

				if module.Init then pcall(module.Init, module) end
				if module.Start then pcall(module.Start, module) end
			else
				warn("Failed to require shared module " .. moduleScript.Name .. ": " .. module)
			end
		end
	end

	-- 🔹 Environment-specific modules
	local envScripts
	local side

	if RunService:IsServer() then
		serverScripts = serverScripts or ServerScriptService:WaitForChild("ModuleLoader"):WaitForChild("Scripts")
		envScripts = serverScripts
		side = "Server"
	elseif RunService:IsClient() then
		localScripts = localScripts or ReplicatedFirst:WaitForChild("ModuleLoader"):WaitForChild("Scripts")
		envScripts = localScripts
		side = "Local"
	end

	if envScripts then
		for _, moduleScript in ipairs(envScripts:GetChildren()) do
			if moduleScript:IsA("ModuleScript") then
				local ok, module = pcall(require, moduleScript)
				if ok then
					module.Services = loader.Services
					cache[moduleScript.Name] = module

					if module.Init then pcall(module.Init, module) end
					if module.Start then pcall(module.Start, module) end
				else
					warn("Failed to require module " .. moduleScript.Name .. ": " .. module)
				end
			end
		end
	end
end

return loader