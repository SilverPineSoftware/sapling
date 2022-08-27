--
--	view.lua
--	Sapling Framework
--
--	Created by Jonathan Hays
--	Copyright © 2022 Silverpine Software. All rights reserved.
--

import 'sapling'

class('View').extends(Drawable)

function View:init()
	View.super.init(self)
	self.subviews = {}
	self.size.width = playdate.display.getWidth()
	self.size.height = playdate.display.getHeight()
end

function View:add(drawable)
	assert(drawable ~= nil)
	assert(drawable.draw)

	self.subviews[#self.subviews + 1] = drawable
	drawable:didAddToParent()
	self:requestRedraw()
end


function View:remove(drawable)
	assert(drawable ~= nil)

	for i = 1, #self.subviews do
		if self.subviews[i] == drawable then
			table.remove(self.subviews, i)
			drawable:didRemoveFromParent()
			self:requestRedraw()
			return
		end
	end
end

function View:setLocation(x, y)
	local xDiff = x - self.location.x
	local yDiff = y - self.location.y

	-- Chain to base class...
	Drawable.setLocation(self, x, y)

	for i = 1, #self.subviews do
		local subview = self.subviews[i]
		local newX = subview.location.x + xDiff
		local newY = subview.location.y + yDiff
		subview:setLocation(newX, newY)
	end

end


function View:offsetLocation(xDistance, yDistance)
	Drawable.offsetLocation(self, xDistance, yDistance)

	for i = 1, #self.subviews do
		local subview = self.subviews[i]
		subview:move(xDistance, yDistance)
	end

end

function View:needsRedraw()
	for i = 1, #self.subviews do
		if self.subviews[i]:needsRedraw() then
			return true
		end
	end

	return Drawable.needsRedraw(self)
end

function View:draw()
	if self:needsRedraw() then
		self:executeDraw()
	end
end

function View:executeDraw()

	local x = self.location.x
	local y = self.location.y
	local width = self.size.width
	local height = self.size.height

	--playdate.graphics.fillRect(x, y, width, height)

	for i = 1,#self.subviews do
		local view = self.subviews[i]
		if view:isHidden() == false then
			view:requestRedraw()
			view:prepareToDraw()
			view:draw()
			view:finishDraw()
		end
	end
end

function View:handleUpPressed()
	for i = #self.subviews, 1, -1 do
		local view = self.subviews[i]
		if view.handleUpPressed ~= nil then
			if view:handleUpPressed() == true then
				return true
				end
		end
	end
	return false
end

function View:handleDownPressed()
	for i = #self.subviews, 1, -1 do
		local view = self.subviews[i]
		if view.handleDownPressed ~= nil then
			if view:handleDownPressed() == true then
				return true
				end
		end
	end
	return false
end

function View:handleLeftPressed()
	for i = #self.subviews, 1, -1 do
		local view = self.subviews[i]
		if view.handleLeftPressed ~= nil then
			if view:handleLeftPressed() == true then
				return true
				end
		end
	end
	return false
end

function View:handleRightPressed()
	for i = #self.subviews, 1, -1 do
		local view = self.subviews[i]
		if view.handleRightPressed ~= nil then
			if view:handleRightPressed() == true then
				return true
			end
		end
	end
	return false
end

function View:handleAPressed()
	for i = #self.subviews, 1, -1 do
		local view = self.subviews[i]
		if view.handleAPressed ~= nil then
			if view:handleAPressed() == true then
				return true
			end
		end
	end
	return false
end

function View:handleBPressed()
	for i = #self.subviews, 1, -1 do
		local view = self.subviews[i]
		if view.handleBPressed ~= nil then
			if view:handleBPressed() == true then
				return true
			end
		end
	end
	return false
end

function View:setActive(active)
	if active == true then
		Engine:addDrawable(self)
		Engine:addInputHandler(self)
	else
		Engine:removeDrawable(self)
		Engine:removeInputHandler(self)
	end
end
