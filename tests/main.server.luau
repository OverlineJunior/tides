local ReplicatedStorage = game:GetService("ReplicatedStorage")

local tides = ReplicatedStorage:FindFirstChild("tides")
	or error("Could not find tides")

local Server = require(tides).Server

Server.addListener("test", function(plr, a, b, c)
	print(`Dudeee, I just got those from {plr.Name}:`, a, b, c)
end)
