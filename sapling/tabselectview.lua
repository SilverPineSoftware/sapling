--
--	tabselectview.lua
--	Sapling Framework
--
--	Created by Jonathan Hays
--	Copyright © 2022 Silverpine Software. All rights reserved.
--

import 'sapling'

local gfx = playdate.graphics

class('TabSelectView').extends(Drawable)

function TabSelectView:init()
	TabSelectView.super.init(self)
	self.buttons = { }
	self.selection = 1
	self.selectionShowing = true
	self:setCornerRadius(4)
	self.selectionEvent = Event(function()
		self:fireSelectionTimer()
	end)

	self.size.width = playdate.display.getWidth()
	self.size.height = 60
end

function TabSelectView:fireSelectionTimer()

	local time = 0.05
	if self.selectionShowing == true then
		self.selectionShowing = false
	else
		self.selectionShowing = true
		time = 2.5
	end

	self:requestRedraw()

	self.selectionEvent:executeAfter(time)
end

function TabSelectView:selectedItem()
	return self.selection
end

function TabSelectView:didAddToParent()
	-- self:fireSelectionTimer()
end

function TabSelectView:resetMenu()
   for i in pairs(self.buttons) do
	  self.buttons[i] = nil
   end
   self.selection = 1
   self:requestRedraw()
end

function TabSelectView:addMenuButton(buttonName)
   local newCount = #self.buttons + 1
   local newButton = ButtonView()
   newButton:setText(buttonName:lower())
   self.buttons[newCount] = newButton
   self:requestRedraw()
end


function TabSelectView:handleDownPressed()
	local buttonCount = #self.buttons
	self.selection = self.selection + 1
	if self.selection > buttonCount then
		self.selection = buttonCount
	end

	self:requestRedraw()
	return true
end

function TabSelectView:handleUpPressed()
   self.selection = self.selection - 1
   if self.selection < 1 then
	  self.selection = 1
   end

   self:requestRedraw()
   return true
end

function TabSelectView:handleRightPressed()
	local buttonCount = #self.buttons
	self.selection = self.selection + 1
	if self.selection > buttonCount then
		self.selection = buttonCount
	end

	self:requestRedraw()
	return true
end

function TabSelectView:handleLeftPressed()
   self.selection = self.selection - 1
   if self.selection < 1 then
	  self.selection = 1
   end

   self:requestRedraw()
   return true
end


function TabSelectView:draw()

	local buttonWidth = (self.size.width / #self.buttons) - 1
	local xOffset = self.location.x
	local yOffset = self.location.y

	gfx.setColor(gfx.kColorBlack)
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
	gfx.setFont(FontManager:currentFont())

	-- Replaces the eraseBackground call we would normally put here
	playdate.graphics.fillRect(self.location.x, yOffset, self.size.width, self.size.height)

	for i = 1,#self.buttons do
		local button = self.buttons[i]
		button.centered = true
		button:setDrawBorder(false)
		if self.selection == i then
			if self.selectionShowing == true then
				button:setDrawBorder(true)
			end
		end

		-- Special case when there's only one button...
		if #self.buttons == 1 then
			buttonWidth = buttonWidth / 2.0
			xOffset = buttonWidth / 2.0
		end

		button:setFrame(xOffset, yOffset + 2, buttonWidth, self.size.height - 1)
		button.size.height = self.size.height - 2
		button:prepareToDraw()
		button:draw()

		xOffset = xOffset + buttonWidth + 1
	end

end

function TabSelectView:isAnimating()
	if self.animationTimer ~= nil then
		return true
	end

	return false
end

function TabSelectView:finishAnimation()
	if self.animationTimer ~= nil then
		self.animationTimer:pause()
		self.animationTimer:remove()
		self.animationTimer.timerEndedCallback(self.animationTimer)
		self.animationTimer = nil
	end

	self:requestRedraw()
end




