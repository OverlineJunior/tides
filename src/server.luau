local RunService = game:GetService("RunService")

local Shared = require(script.Parent.shared)

type Map<K, V> = Shared.Map<K, V>
type EventId = Shared.EventId
type Packet = Shared.Packet
type ListenerFn = (sender: Player, args: {any}) -> nil

local reliable = Shared.getReliable()
local unreliable = Shared.getUnreliable()
local outgoingPackets: Map<Player, {Packet}> = {}
local listeners: Map<EventId, {ListenerFn}> = {}

local function flushPackets()
	for plr, pkts in outgoingPackets do
		if next(pkts) then
			reliable:FireClient(plr, pkts)
		end

		outgoingPackets[plr] = nil
	end
end

local function callListeners(sender: Player, eventId: EventId, ...)
	if listeners[eventId] then
		for _, listener in listeners[eventId] do
			listener(sender, ...)
		end
	end
end

local function consumePackets(sender: Player, packets: {Packet})
	assert(packets, "Should not be fired without incoming packets")

	for _, pkt in packets do
		callListeners(sender, pkt.eventId, table.unpack(pkt.args))
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

function Server.addListener(eventId: EventId, callback: ListenerFn)
	if listeners[eventId] then
		table.insert(listeners[eventId], callback)
	else
		listeners[eventId] = {callback}
	end
end

function Server.start()
	RunService.Stepped:Connect(flushPackets)
	reliable.OnServerEvent:Connect(consumePackets)
	unreliable.OnServerEvent:Connect(callListeners)
end

return Server
