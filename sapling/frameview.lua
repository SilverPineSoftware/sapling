--
--	frameview.lua
--	Sapling Framework
--
--	Created by Jonathan Hays
--	Copyright © 2022 Silverpine Software. All rights reserved.
--


import 'sapling'

class('FrameView').extends(View)

function FrameView:init()
	FrameView.super.init(self)
	self.size.width = playdate.display.getWidth()
	self.size.height = playdate.display.getHeight()
	self:setDrawBorder(true)
end

