local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local tides = ReplicatedStorage:FindFirstChild("tides")
	or error("Could not find tides")

local Server = require(tides).Server

Server.addListener("test", function(plr, a, b)
	print(`Dudeee, I just got those from {plr.Name}:`, a, b)
end)

Players.PlayerAdded:Connect(function(plr)
	Server.sendReliable(plr, "test", "I am reliable!", 111)
	Server.sendUnreliable(plr, "test", "I am unreliable!", 222)
end)
