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
end

function Event:execute()
	self.time = playdate.getCurrentTimeMilliseconds()
	Dispatch:queue(self)
end


function Event:executeAfter(seconds)
	local currentTime = playdate.getCurrentTimeMilliseconds()
	self.time = currentTime + (1000 * seconds)
	Dispatch:queue(self)
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

function Dispatch:process()

	-- We make a copy of the events that we want to fire
	local firedEvents = { }
	local count = #Dispatch.events
	for i = 1,count do
		local event = Dispatch.events[i]
		if event.time ~= nil then
			local currentTime = playdate.getCurrentTimeMilliseconds()
			if currentTime >= event.time then
				firedEvents[#firedEvents + 1] = event
			end
		else
			firedEvents[#firedEvents + 1] = event
		end
	end

	-- First remove them from the queue
	for x = 1, #firedEvents do
		local event = firedEvents[x]
		Dispatch:dequeue(firedEvents[x])
	end

	-- Then let them process
	for x = 1, #firedEvents do
		local event = firedEvents[x]
		event.execution()
	end
end



