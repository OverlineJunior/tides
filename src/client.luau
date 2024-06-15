local RunService = game:GetService("RunService")
local Shared = require(script.Parent.shared)

type Map<K, V> = Shared.Map<K, V>
type EventId = Shared.EventId
type Packet = Shared.Packet
type ListenerFn = (args: {any}) -> nil

local reliable = Shared.getReliable()
local unreliable = Shared.getUnreliable()
local outgoingPackets: {Packet} = {}
local listeners: Map<EventId, {ListenerFn}> = {}

local function flushPackets()
	reliable:FireServer(outgoingPackets)
	table.clear(outgoingPackets)
end

local function consumePackets(packets: {Packet})
	assert(packets, "Should not be fired without incoming packets")

	for _, pkt in packets do
		local eventId = pkt.eventId

		if listeners[eventId] then
			for _, listener in listeners[eventId] do
				listener(table.unpack(pkt.args))
			end
		end
	end
end

local Client = {}

function Client.sendReliable(eventId: EventId, ...)
	local packet = {
		eventId = eventId,
		args = {...},
	}

	table.insert(outgoingPackets, packet)
end

function Client.sendUnreliable(eventId: EventId, ...)
	unreliable:FireServer(eventId, ...)
end

function Client.addListener(eventId: EventId, callback: ListenerFn)
	if listeners[eventId] then
		table.insert(listeners[eventId], callback)
	else
		listeners[eventId] = {callback}
	end
end

function Client.start()
	RunService.Stepped:Connect(flushPackets)
	reliable.OnClientEvent:Connect(consumePackets)
end

return Client
