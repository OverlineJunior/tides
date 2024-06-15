local RunService = game:GetService("RunService")

local Shared = require(script.shared)

if RunService:IsServer() then
	Shared.makeRemotes()
	require(script.server).start()
else
	Shared.waitForRemotes()
	require(script.client).start()
end

return {
	Server = require(script.server),
	Client = require(script.client),
}
