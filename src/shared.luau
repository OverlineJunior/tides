local ReplicatedStorage = game:GetService("ReplicatedStorage")

export type Map<K, V> = { [K]: V }
export type EventId = string

export type Packet = {
	eventId: EventId,
	args: {any},
}

local REMOTE_CONTAINER = ReplicatedStorage
local RELIABLE_NAME = "__tides_reliable__"
local UNRELIABLE_NAME = "__tides_unreliable__"
local ERR_UNLOADED_REMOTES = "Remotes should be loaded before getting them"

local Shared = {}

function Shared.makeRemotes()
	local r = Instance.new("RemoteEvent")
	r.Name = RELIABLE_NAME
	r.Parent = REMOTE_CONTAINER

	local u = Instance.new("UnreliableRemoteEvent")
	u.Name = UNRELIABLE_NAME
	u.Parent = REMOTE_CONTAINER
end

function Shared.waitForRemotes()
	REMOTE_CONTAINER:WaitForChild(RELIABLE_NAME)
	REMOTE_CONTAINER:WaitForChild(UNRELIABLE_NAME)
end

function Shared.getReliable(): RemoteEvent
	return REMOTE_CONTAINER:FindFirstChild(RELIABLE_NAME)
		or error(ERR_UNLOADED_REMOTES)
end

function Shared.getUnreliable(): UnreliableRemoteEvent
	return REMOTE_CONTAINER:FindFirstChild(UNRELIABLE_NAME)
		or error(ERR_UNLOADED_REMOTES)
end

return Shared
