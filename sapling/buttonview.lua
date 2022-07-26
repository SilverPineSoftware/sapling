--
--	buttonview.lua
--	Sapling Framework
--
--	Created by Jonathan Hays
--	Copyright © 2022 Silverpine Software. All rights reserved.
--
--

import 'sapling'

local gfx = playdate.graphics

class('ButtonView').extends(TextView)

function ButtonView:init(text)
	TextView.super.init(self)
	self.text = text
	self.lines = {}
	self.centered = true
	self:setCornerRadius(4)
	self:setDrawBorder(true)
	self.lines = self:getLines(self.text)
end

function ButtonView:showFocusRing(show)
	if show == true then
		if self.focusRing == nil then
			self.focusRing = FrameView()
			self.focusRing.cornerRadius = self.cornerRadius
			self.focusRing.location.x = self.location.x - 2
			self.focusRing.location.y = self.location.y - 2
			self.focusRing.size.width = self.size.width + 4
			self.focusRing.size.height = self.size.height + 4
			self:add(self.focusRing)
		end

		self.focusRing:setHidden(false)
	else
		if self.focusRing ~= nil then
			self.focusRing:setHidden(true)
		end
	end

end

