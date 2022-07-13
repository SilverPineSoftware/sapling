--
--	inputhandler.lua
--	Sapling Framework
--
--	Created by Jonathan Hays
--	Copyright © 2022 Silverpine Software. All rights reserved.
--
--

import 'sapling'

class('InputHandler').extends(Object)

function InputHandler:init()
	InputHandler.super.init(self)
end

function InputHandler:handleUpPressed()
	return false
end

function InputHandler:handleDownPressed()
	return false
end

function InputHandler:handleLeftPressed()
	return false
end

function InputHandler:handleRightPressed()
	return false
end

function InputHandler:handleAPressed()
	return false
end

function InputHandler:handleBPressed()
	return false
end
