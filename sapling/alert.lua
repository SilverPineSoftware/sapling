--
--	alert.lua
--	Sapling Framework
--
--	Created by Jonathan Hays
--	Copyright © 2022 Silverpine Software. All rights reserved.
--
--
-- Usage:
--	Alert("This is a message. What will it look like?", "OK")
--


import 'sapling'

class('Alert').extends(View)

function Alert:init(message, button)
	Alert.super.init(self)

	self:setCornerRadius(2)
	self:setDrawBorder(true)
	self.location.x = 40
	self.size.width = playdate.display.getWidth() - 80
	self.size.height = 100
	self.location.y = (playdate.display.getHeight() - self.size.height) / 2.0

	self.messageView = TextView()
	self.messageView.location.y = self.location.y + 10
	self.messageView.location.x = self.location.x + 20
	self.messageView.size.width = self.size.width - 40
	self.messageView:setText(message)
	self:add(self.messageView)

	self.buttonView = ButtonView(button:lower())
	--self.buttonView:setText(button)
	self.buttonView:centerHorizontally()
	self.buttonView.size.width = self.buttonView.size.width + 20
	self.buttonView.location.x = (playdate.display.getWidth() - self.buttonView.size.width) / 2.0
	self.buttonView.location.y = self.location.y + self.size.height - (self.buttonView.size.height + 10.0)

	self:add(self.buttonView)
	self.previousFocusedObject = Engine.focusedObject
	self:setActive(true)
end

function Alert:handleAPressed()
	self:setActive(false)
	if self.completion ~= nil then
		self.completion()
	end
	return true
end

function Alert:handleBPressed()
	self:setActive(false)
	if self.completion ~= nil then
		self.completion()
	end
	return true
end

function Alert:setCompletion(completion)
	self.completion = completion
end


class('TwoButtonAlert').extends(View)

function TwoButtonAlert:init(message, buttonB, buttonA)
	TwoButtonAlert.super.init(self)

	self:setCornerRadius(2)
	self:setDrawBorder(true)
	self.location.x = 40
	self.size.width = playdate.display.getWidth() - 80
	self.size.height = 100
	self.location.y = (playdate.display.getHeight() - self.size.height) / 2.0

	self.messageView = TextView()
	self.messageView.location.y = self.location.y + 10
	self.messageView.location.x = self.location.x + 20
	self.messageView.size.width = self.size.width - 40
	self.messageView:setText(message)
	self:add(self.messageView)

	self.aButtonView = ButtonView(buttonA:lower())
	self.aButtonView:centerHorizontally()
	self.aButtonView.size.width = self.aButtonView.size.width + 20
	self.aButtonView.location.x = (playdate.display.getWidth() - self.aButtonView.size.width) / 2.0
	self.aButtonView.location.y = self.location.y + self.size.height - (self.aButtonView.size.height + 10.0)
	self:add(self.aButtonView)

	self.bButtonView = ButtonView(buttonB:lower())
	self.bButtonView:centerHorizontally()
	self.bButtonView.size.width = self.bButtonView.size.width + 20
	self.bButtonView.location.x = (playdate.display.getWidth() - self.bButtonView.size.width) / 2.0
	self.bButtonView.location.y = self.location.y + self.size.height - (self.bButtonView.size.height + 10.0)
	self:add(self.bButtonView)

	self.bButtonView.location.x = (playdate.display.getWidth() / 2) - self.bButtonView.size.width - 10
	self.aButtonView.location.x = (playdate.display.getWidth() / 2) + 10

	self.previousFocusedObject = Engine.focusedObject
	self:setActive(true)
end

function TwoButtonAlert:handleAPressed()
	self:setActive(false)
	if self.aCompletion ~= nil then
		self.aCompletion()
	end
	return true
end

function TwoButtonAlert:handleBPressed()
	self:setActive(false)
	if self.bCompletion ~= nil then
		self.bCompletion()
	end
	return true
end

function TwoButtonAlert:setACompletion(completion)
	self.aCompletion = completion
end

function TwoButtonAlert:setBCompletion(completion)
	self.bCompletion = completion
end


class('CustomAlert').extends(View)

function CustomAlert:init(message)
	CustomAlert.super.init(self)

	self:setCornerRadius(2)
	self:setDrawBorder(true)
	self.location.x = 40
	self.size.width = playdate.display.getWidth() - 80
	self.size.height = 125
	self.location.y = (playdate.display.getHeight() - self.size.height) / 2.0

	self.messageView = TextView()
	self.messageView.location.y = self.location.y + 10
	self.messageView.location.x = self.location.x + 20
	self.messageView.size.width = self.size.width - 40
	self.messageView:setText(message)
	self:add(self.messageView)

	self.buttonCollection = 	TabSelectView()
	self.buttonCollection.size.width = self.size.width - 10
	self.buttonCollection.location.x = self.location.x + 5
	self.buttonCollection.size.height = 22
	self:add(self.buttonCollection)
	self.buttonCollection.location.y = self.location.y + self.size.height - (self.buttonCollection.size.height + 10.0)
	self.buttonCollection:centerHorizontally()

	self.actions = {}
	self.buttons = {}

	self.previousFocusedObject = Engine.focusedObject
	self:setActive(true)
	self.buttonCollection:fireSelectionTimer()
end

function CustomAlert:addButton(text, func)
	self.actions[#self.actions + 1] = func
	self.buttons[#self.buttons + 1] = text
	self.buttonCollection:addMenuButton(text)
	self.buttonCollection:centerHorizontally()
end

function CustomAlert:handleAPressed()
	self:setActive(false)
	local selected = self.buttonCollection:selectedItem()
	local func = self.actions[selected]
	if func ~= nil then
		func()
	end
	return true
end

function CustomAlert:handleBPressed()
	-- Intercept
	return true
end

