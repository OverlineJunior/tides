local ReplicatedStorage = game:GetService("ReplicatedStorage")

local tides = ReplicatedStorage:FindFirstChild("tides")
	or error("Could not find tides")

local Client = require(tides).Client

Client.sendReliable("test", 555, 333, 111)
