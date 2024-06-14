local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local tides = ReplicatedStorage:FindFirstChild("tides")
	or error("Could not find tides")

local Server = require(tides).Server

Players.PlayerAdded:Connect(function(plr)
	Server.sendReliable(plr, "test", 1, "hello!", true)
end)
