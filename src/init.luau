local RunService = game:GetService("RunService")

local Server = require(script.server)
local Client = require(script.client)
local Shared = require(script.shared)

print("module running")

if RunService:IsServer() then
	Shared.makeRemotes()
	Server.start()
else
	Shared.waitForRemotes()
	Client.start()
end

return {
	Server = Server,
	Client = Client,
}
