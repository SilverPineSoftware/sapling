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

