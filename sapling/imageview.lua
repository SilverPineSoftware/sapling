--
--	imageview.lua
--	Sapling Framework
--
--	Created by Jonathan Hays
--	Copyright © 2022 Silverpine Software. All rights reserved.
--


import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'drawable'

local gfx = playdate.graphics

class('ImageView').extends(Drawable)

function ImageView:init(imageName)
	ImageView.super.init(self)
	self:setImage(imageName)
end

function ImageView:setImage(imageName)
	-- Bail if a nil image is set
	if imageName == nil or #imageName == 0 then
		self:requestRedraw()
		return
	end

	local image = gfx.image.new(imageName)
	if image ~= nil then
		local width, height = playdate.graphics.imageSizeAtPath(imageName)
		self.image = image
		self.size.width = width
		self.size.height = height
	end
	self:requestRedraw()
end


function ImageView:draw()
	gfx.setImageDrawMode(gfx.kDrawModeCopy)

	if self.image ~= nil then
		self.image:draw(self.location.x, self.location.y)
	end
end