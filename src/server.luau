local RunService = game:GetService("RunService")

local Shared = require(script.Parent.shared)

type Map<K, V> = Shared.Map<K, V>
type EventId = Shared.EventId
type Packet = Shared.Packet

local reliable = Shared.getReliable()
local unreliable = Shared.getUnreliable()
local outgoingPackets: Map<Player, {Packet}> = {}

local function flushPackets()
	for plr, pkt in outgoingPackets do
		if next(pkt) then
			reliable:FireClient(plr, pkt)
		end

		outgoingPackets[plr] = nil
	end
end

local Server = {}

function Server.sendReliable(receiver: Player, eventId: EventId, ...)
	local packet = {
		eventId = eventId,
		args = {...},
	}

	local packets = outgoingPackets[receiver]
	if packets then
		table.insert(packets, packet)
	else
		outgoingPackets[receiver] = {packet}
	end
end

function Server.sendUnreliable(receiver: Player, eventId: EventId, ...)
	unreliable:FireClient(receiver, eventId, ...)
end

function Server.start()
	RunService.Stepped:Connect(flushPackets)
end

return Server
