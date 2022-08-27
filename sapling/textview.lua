--
--	textview.lua
--	Sapling Framework
--
--	Created by Jonathan Hays
--	Copyright © 2022 Silverpine Software. All rights reserved.
--

import 'sapling'

local gfx = playdate.graphics

class('TextView').extends(Drawable)

function TextView:init(text)
	TextView.super.init(self)
	self.text = text
	self.lines = {}
	self.centered = false
	self.lines = self:getLines(self.text)
end

-- Height for a Text object is calculated, so override
function TextView:calculateHeight()
	return #self.lines * FontManager:currentFontHeight()
end

function TextView:getTextSize()
	local w = 0
	local font = FontManager:currentFont()
	for i = 1,#self.lines do
		local line = self.lines[i]
		local width = font:getTextWidth(line)
		if width > w then
			w = width
		end
	end

	local h = self:calculateHeight()
	return { width = w, height = h }
end

function TextView:getFrameSize()
	local size = self.size
	size.height = self:calculateHeight()
	return size
end

function TextView:setText(paragraph)
	self.text = paragraph:lower()
	self.lines = self:getLines(self.text)
	self.size.height = self:calculateHeight()
	self:requestRedraw()
end

function TextView:sizeToText()
	local size = self:getTextSize()
	self.size.width = size.width + 8
	self.size.height = size.height
	self:requestRedraw()
end

function TextView:setFrame(x, y, w, h)
	self.location.x = x
	self.location.y = y
	self.size.width = w
	self.lines = self:getLines(self.text)
	self.size.height = self:calculateHeight()
	self:requestRedraw()
end

function TextView:centerHorizontally()
	-- Make sure we are sized properly
	self:sizeToText()

	local width = self.size.width
	local screenWidth = playdate.display.getWidth()
    self.location.x = (screenWidth - width) / 2
	self:requestRedraw()
end

function TextView:getLines(text)
	local newLines = {}
	local lineCount = 1

	-- If no text, then bail early...
	if text == nil then
		return newLines
	end

	-- If a width hasn't been set, then set to the display width
	local width = self.size.width
	if width == 0 then
		width = playdate.display.getWidth()
	end

	-- Leave 4 pixels on each edge for a border
	local frameWidth = width - 8

	local line = ""
	local font = FontManager:currentFont()
	for token in string.gmatch(text, "[^%s]+") do
		local newLine = line
		if #newLine > 0 then
			newLine = newLine .. " "
		end
		newLine = newLine .. token
		local width = font:getTextWidth(newLine)
		if width > frameWidth then
			-- We have to do this, in case the first line is too long
			if #line <= 0 then
				line = newLine
				token = ""
			end
			newLines[lineCount] = line
			line = token
			lineCount = lineCount + 1
		else
			line = newLine
		end
	end

	if #line > 0 then
		newLines[lineCount] = line
		lineCount = lineCount + 1
	end

	return newLines
end


function TextView:draw()
	self:drawLines(self.lines)
end

function TextView:drawLines(lines)
	local x = self.location.x
	local y = self.location.y

	local textSize = self:getTextSize()

	local lineCount = #lines
	local width = textSize.width
	local height = self:calculateHeight()

	gfx.setFont(FontManager:currentFont())

	local lineHeight = FontManager:currentFontHeight()
	local totalTextHeight = lineHeight * lineCount
	local xCenteredOffset = self.location.x + (self.size.width / 2)

	local yOffset = y
	if self.centered then
		yOffset = self.location.y + ((self.size.height - totalTextHeight) / 2)
	end

	gfx.setColor(gfx.kColorWhite)
	gfx.setImageDrawMode(playdate.graphics.kDrawModeNXOR)
	for i = 1,lineCount do
		local line = lines[i]
		if self.centered == true then
			gfx.drawTextAligned(line, xCenteredOffset, yOffset, kTextAlignment.center)
		else
			gfx.drawTextAligned(line, x + 4,  yOffset, kTextAlignment.left)
		end
		yOffset = yOffset + lineHeight
	end

end


