--
--	scrollabletextview.lua
--	Sapling Framework
--
--	Created by Jonathan Hays
--	Copyright © 2022 Silverpine Software. All rights reserved.
--

import 'sapling'

local gfx = playdate.graphics

class('ScrollableTextView').extends(TextView)

function ScrollableTextView:init(text)
	ScrollableTextView.super.init(self, text)
	self.drawingOffset = 0
end

function ScrollableTextView:handleDownPressed()

	if self.size.height + self.drawingOffset < self.location.y then
		return
	end

	self.drawingOffset = self.drawingOffset - 10
	self:requestRedraw()

	if self.repeatEvent ~= nil then
		self.repeatEvent:cancel()
		self.repeatEvent = nil
	end

	self.repeatEvent = Event(function()
		self.repeatEvent = nil
		self:handleDownPressed()
	end)
	self.repeatEvent:executeAfter(0.01)
end

function ScrollableTextView:handleUpPressed()
	self.drawingOffset = self.drawingOffset + 10
	if self.drawingOffset > 0 then
		self.drawingOffset = 0
	end

	self:requestRedraw()

	if self.repeatEvent ~= nil then
		self.repeatEvent:cancel()
		self.repeatEvent = nil
	end

	self.repeatEvent = Event(function()
		self.repeatEvent = nil
		self:handleUpPressed()
	end)
	self.repeatEvent:executeAfter(0.01)

end

function ScrollableTextView:handleUpReleased()
	if self.repeatEvent ~= nil then
		self.repeatEvent:cancel()
		self.repeatEvent = nil
	end
end


function ScrollableTextView:handleDownReleased()
	if self.repeatEvent ~= nil then
		self.repeatEvent:cancel()
		self.repeatEvent = nil
	end
end


function ScrollableTextView:draw()
	gfx.setClipRect(self.location.x, self.location.y, self.size.width, self.size.height)
	local currentY = self.location.y
	self.location.y = currentY + self.drawingOffset
	self:drawLines(self.lines)
	self.location.y = currentY
	gfx.clearClipRect()
end
