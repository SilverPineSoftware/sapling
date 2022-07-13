--
--	fontmanager.lua
--	Sapling Framework
--
--	Created by Jonathan Hays
--	Copyright © 2022 Silverpine Software. All rights reserved.
--


import 'sapling'

class('FontManager').extends(Object)

local currentFont = playdate.graphics.getSystemFont(playdate.graphics.font.kVariantNormal)

function FontManager:setCurrentFont(name)
	local newFont = playdate.graphics.font.new(name)
	if newFont ~= nil then
		currentFont = newFont
	end
end

function FontManager:currentFont()
	return currentFont
end

-- Convenience function
function FontManager:currentFontHeight()
	return currentFont:getHeight()
end