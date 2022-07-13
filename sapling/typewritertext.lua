--
--	typewritertext.lua
--	Sapling Framework
--
--	Created by Jonathan Hays
--	Copyright © 2022 Silverpine Software. All rights reserved.
--

import 'sapling'

local gfx = playdate.graphics

class('TypewriterText').extends(TextView)

function TypewriterText:init(text)
	TypewriterText.super.init(self)
	self.timer = Event(function() self:advance() end)
	self.wordIndex = 0
	self.totalWords = 0
	self.speed = 0.05
end

function TypewriterText:setText(paragraph)
	self.text = paragraph:lower()
	self.lines = self:getLines(self.text)

	self.wordIndex = 0
	self.totalWords = 0
	for token in string.gmatch(self.text, "[^%s]+") do
		self.totalWords = self.totalWords + 1
	end

	-- If the width is 0, it means we should auto set it to the size of the text...
	if self.size.width == 0 then
		self.size.width = self:getTextSize().width
	end
	self.size.height = self:calculateHeight()
	self:requestRedraw()
end

function TypewriterText:beginAnimation()
	self.wordIndex = 0
	self:advance()
end

function TypewriterText:setEndOfAnimationEvent(event)
	self.endOfAnimationEvent = event
end

function TypewriterText:isAnimating()
	return self.totalWords >= self.wordIndex
end

function TypewriterText:finishAnimation()
	self.wordIndex = self.totalWords + 1
	if self.endOfAnimationEvent ~= nil then
		self.endOfAnimationEvent:execute()
		self.endOfAnimationEvent = nil
	end

	self:requestRedraw()
end

function TypewriterText:advance()
	self.wordIndex = self.wordIndex + 1
	if self.wordIndex <= self.totalWords then
		self.timer:executeAfter(self.speed)
	else
		if self.endOfAnimationEvent ~= nil then
			self.endOfAnimationEvent:execute()
			self.endOfAnimationEvent = nil
		end
	end

	self:requestRedraw()
end


function TypewriterText:draw()
	gfx.setColor(gfx.kColorBlack)
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)

	self:eraseBackground()

	local textCopy = ""
	local index = 0
	for token in string.gmatch(self.text, "[^%s]+") do
		index = index + 1
		if index < self.wordIndex then
			textCopy = textCopy .. " " .. token
		end
	end

	local lines = self:getLines(textCopy)
	self:drawLines(lines)
end