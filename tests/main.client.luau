local ReplicatedStorage = game:GetService("ReplicatedStorage")

local tides = ReplicatedStorage:FindFirstChild("tides")
	or error("Could not find tides")

local Client = require(tides).Client

Client.addListener("test", function(a, b)
	print(`Dudeee, I just got those from the server!:`, a, b)
end)

Client.sendReliable("test", "I am reliable!", 111)
Client.sendUnreliable("test", "I am unreliable!", 222)
