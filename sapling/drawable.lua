--
--	drawable.lua
--	Sapling Framework
--
--	Created by Jonathan Hays
--	Copyright © 2022 Silverpine Software. All rights reserved.
--


import 'sapling'

local gfx = playdate.graphics

class('Drawable').extends(InputHandler)

function Drawable:init()
	Drawable.super.init(self)

	self.location = { x = 0, y = 0 }
	self.size = { width = 0, height = 0 }
	self.dirty = true
	self.hidden = false
	self.drawBorder = false
	self.cornerRadius = 0
end

function Drawable:isHidden()
	return self.hidden
end

function Drawable:setHidden(hidden)
	self.hidden = hidden
	self:requestRedraw()
end

function Drawable:setFrame(x, y, w, h)
	self.location.x = x
	self.location.y = y
	self.size.width = w
	self.size.height = h
	self:requestRedraw()
end

function Drawable:setCornerRadius(radius)
	self.cornerRadius = radius
	self:requestRedraw()
end

function Drawable:setDrawBorder(shouldDraw)
	self.drawBorder = shouldDraw
	self:requestRedraw()
end

function Drawable:setLocation(x, y)
	self.location.x = x
	self.location.y = y
	self:requestRedraw()
end

function Drawable:offsetLocation(xDistance, yDistance)
	self.location.x = self.location.x + xDistance
	self.location.y = self.location.y + yDistance
	self:requestRedraw()
end

function Drawable:eraseBackground()

	playdate.graphics.setColor(playdate.graphics.kColorBlack)
	if self.cornerRadius == 0 then
		playdate.graphics.fillRect(self.location.x, self.location.y, self.size.width, self.size.height)
	else
		playdate.graphics.fillRoundRect(self.location.x, self.location.y, self.size.width, self.size.height, self.cornerRadius)
	end


	if self.drawBorder == true then
		gfx.setColor(gfx.kColorWhite)

		if self.cornerRadius == 0 then
			gfx.drawRect(self.location.x, self.location.y, self.size.width, self.size.height)
		else
			gfx.drawRoundRect(self.location.x, self.location.y, self.size.width, self.size.height, self.cornerRadius)
		end
	end


end

function Drawable:centerHorizontally()
	local width = self:getWidth()
	local screenWidth = playdate.display.getWidth()
	self.location.x = (screenWidth - width) / 2
	self:requestRedraw()
end

function Drawable:getWidth()
	return self.size.width
end

function Drawable:getHeight()
	return self.size.height
end

function Drawable:didAddToParent()
end

function Drawable:didRemoveFromParent()
end

function Drawable:isOnScreen()
	if self.location.y < playdate.display.getHeight() and self.location.y >= 0 and
	   self.location.x < playdate.display.getWidth() and self.location.x >= 0 then
		   return true
	end

	return false
end

function Drawable:requestRedraw()
	self.dirty = true
end

function Drawable:needsRedraw()
	return self.dirty and self:isOnScreen()
end

function Drawable:prepareToDraw()
	self.savedImageDrawMode = gfx.getImageDrawMode()
	self.savedColor = gfx.getColor()

	self:eraseBackground()
end

function Drawable:draw()
end

function Drawable:finishDraw()
	gfx.setImageDrawMode(self.savedImageDrawMode)
	gfx.setColor(self.savedColor)
	self.dirty = false
end

function Drawable:isAnimating()
	return self.animationTimer ~= nil
end

function Drawable:animateToVerticalLocation(yOffset)

	self.animationTimer = playdate.timer.new(250, self.location.y, yOffset, playdate.easingFunctions.outCubic)

	self.animationTimer.updateCallback = function(timer)
		self:setLocation(self.location.x, timer.value)
	end

	self.animationTimer.timerEndedCallback = function(timer)
		self:setLocation(self.location.x, yOffset)
		self.animationTimer = nil
	end
end

function Drawable:animateToHorizontalLocation(xOffset)

	self.animationTimer = playdate.timer.new(250, self.location.x, xOffset, playdate.easingFunctions.outCubic)

	self.animationTimer.updateCallback = function(timer)
		self:setLocation(timer.value, self.location.y)
	end

	self.animationTimer.timerEndedCallback = function(timer)
		self:setLocation(yOffset, self.location.y)
		self.animationTimer = nil
	end
end
