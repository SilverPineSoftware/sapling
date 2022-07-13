--
--	verticalstackview.lua
--	Sapling Framework
--
--	Created by Jonathan Hays
--	Copyright © 2022 Silverpine Software. All rights reserved.
--

import 'sapling'

local gfx = playdate.graphics

class('VerticalStackView').extends(Drawable)

function VerticalStackView:init()
	VerticalStackView.super.init(self)
	self.buttons = { }
	self.selection = 1
	self.selectionShowing = false
	self.rowHeight = FontManager:currentFontHeight() + 10
	self.selectionEvent = Event(function()
		self:fireSelectionTimer()
	end)
end

function VerticalStackView:fireSelectionTimer()
	if self.selectionShowing == true then
		self.selectionShowing = false
	else
		self.selectionShowing = true
	end

	self:requestRedraw()

	self.selectionEvent:executeAfter(0.75)
end

function VerticalStackView:didAddToParent()
	self:fireSelectionTimer()
end

function VerticalStackView:calculateHeight()
	local lineHeight = self.rowHeight
	return #self.buttons * lineHeight
end

function VerticalStackView:setRowHeight(height)
	self.rowHeight = height
	self:requestRedraw()
end

function VerticalStackView:resetMenu()
   for i in pairs(self.buttons) do
	  self.buttons[i] = nil
   end
   self:requestRedraw()
end

function VerticalStackView:addMenuButton(buttonName)
   local newCount = #self.buttons + 1
   local newButton = TextView()
   newButton.centered = true
   newButton:setText(buttonName)
   newButton.size.height = self.rowHeight
   newButton.size.width = self.size.width
   self.buttons[newCount] = newButton

   self:requestRedraw()
end

function VerticalStackView:removeMenuButton(buttonName)
	for i = 1,#self.buttons do
		local button = self.buttons[i]
		if button.text == buttonName then
			table.remove(self.buttons, i)
			self:requestRedraw()
			return
		end
	end
end



function VerticalStackView:setFrame(x, y, w, h)
	self.location.x = x
	self.location.y =  y
	self.size.width = w
	self.size.height = h

	self.rowHeight = self.size.height / #self.buttons
	for i = 1,#self.buttons do
		local button = self.buttons[i]
		button.size.width = self.size.width
		button.size.height = self.rowHeight
	end

	self:requestRedraw()
end



function VerticalStackView:draw()

	gfx.setColor(gfx.kColorBlack)
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)

	local yOffset = self.location.y

    for i = 1,#self.buttons do
		local button = self.buttons[i]

	  -- Show the selection indicator if we need to...
	  if (self.selection == i) and (self.selectionShowing == true) then
		  button:setDrawBorder(true)
	  else
		  button:setDrawBorder(false)
	  end

	  button.location.x = self.location.x
	  button.location.y = yOffset
	  button:prepareToDraw()
	  button:draw()
	  yOffset = yOffset + self.rowHeight
   end

end


function VerticalStackView:handleDownPressed()
	local buttonCount = #self.buttons
	self.selection = self.selection + 1
    if self.selection > buttonCount then
		self.selection = buttonCount
	end

	self:requestRedraw()
	return true
end

function VerticalStackView:handleUpPressed()
   self.selection = self.selection - 1
   if self.selection < 1 then
	  self.selection = 1
   end

   self:requestRedraw()
   return true
end

function VerticalStackView:selectedRow()
	return self.selection
end


