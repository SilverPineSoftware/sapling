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
	return true
end

function Alert:handleBPressed()
	self:setActive(false)
	return true
end
