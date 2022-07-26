--
--	event.lua
--	Sapling Framework
--
--	Created by Jonathan Hays
--	Copyright © 2022 Silverpine Software. All rights reserved.
--


import 'CoreLibs/object'

class('Event').extends(Object)

function Event:init(func)
	Event.super.init(self)
	self.execution = func
	self.time = nil
	self.delay = 1
	self.repeats = false
end

function Event:execute()
	self.time = playdate.getCurrentTimeMilliseconds()
	Dispatch:queue(self)
end


function Event:executeAfter(seconds)
	local currentTime = playdate.getCurrentTimeMilliseconds()
	self.delay = 1000 * seconds
	self.time = currentTime + (1000 * seconds)
	Dispatch:queue(self)
end

function Event:cancel()
	self.repeats = false
	self.time = nil
	Dispatch:dequeue(self)
end

Dispatch = { events = { } }

function Dispatch:queue(event)
	local next = #Dispatch.events + 1
	Dispatch.events[next] = event
end

function Dispatch:dequeue(event)
	assert(event ~= nil)

	for i = 1, #Dispatch.events do
		if Dispatch.events[i] == event then
			table.remove(Dispatch.events, i)
			return
		end
	end
end

function Dispatch:isQueued(event)
	for i = 1, #Dispatch.events do
		if Dispatch.events[i] == event then
			return true
		end
	end

	return false
end

function Dispatch:process()

	local currentTime = playdate.getCurrentTimeMilliseconds()

	-- We make a copy of the events that we want to fire
	local firedEvents = { }
	local count = #Dispatch.events
	for i = 1,count do
		local event = Dispatch.events[i]
		if event.time ~= nil then
			if currentTime >= event.time then
				firedEvents[#firedEvents + 1] = event
			end
		else
			firedEvents[#firedEvents + 1] = event
		end
	end

	-- First let them process
	for x = 1, #firedEvents do
		local event = firedEvents[x]
		-- Check to see if the event is still in the queue. Sometimes when one event triggers, it will cause
		--    another event to get dequeued, so let's see if this event is still wanting to fire...
		if Dispatch:isQueued(event) then
			event.execution()
		end
	end

	-- Then remove them from the queue
	for x = 1, #firedEvents do
		local event = firedEvents[x]
		if event.repeats == true then
			event.time = currentTime + event.delay
		else
			Dispatch:dequeue(firedEvents[x])
		end
	end

end



