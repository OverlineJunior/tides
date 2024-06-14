local ReplicatedStorage = game:GetService("ReplicatedStorage")

local tides = ReplicatedStorage:FindFirstChild("tides")
	or error("Could not find tides")

local Client = require(tides).Client

Client.addListener("test", function(a, b, c)
	print("Received test event with:", a, b, c)
end)
