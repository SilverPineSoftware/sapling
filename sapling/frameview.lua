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

function FrameView:prepareToDraw()
	local gfx = playdate.graphics
	self.savedImageDrawMode = gfx.getImageDrawMode()
	self.savedColor = gfx.getColor()

	if self.drawBorder == true then
		gfx.setColor(gfx.kColorWhite)

		if self.cornerRadius == 0 then
			gfx.drawRect(self.location.x, self.location.y, self.size.width, self.size.height)
		else
			gfx.drawRoundRect(self.location.x, self.location.y, self.size.width, self.size.height, self.cornerRadius)
		end
	end

	--self:eraseBackground()
end
