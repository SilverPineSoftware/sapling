--
--	engine.lua
--	Sapling Framework
--
--	Created by Jonathan Hays
--	Copyright © 2022 Silverpine Software. All rights reserved.
--


import 'sapling'

Engine = { drawables = { }, inputHandlers = { } }

function Engine:addInputHandler(obj)
	assert(obj)
	Engine.inputHandlers[#Engine.inputHandlers + 1] = obj
end

function Engine:removeInputHandler(obj)
	assert(obj ~= nil)

	for i = 1, #Engine.inputHandlers do
		if Engine.inputHandlers[i] == obj then
			table.remove(Engine.inputHandlers, i)
			return
		end
	end
end

function Engine:handleUpPressed()
	for i = #Engine.inputHandlers, 1, -1 do
		local inputHandler = Engine.inputHandlers[i]
		if inputHandler:handleUpPressed() == true then
			return true
		end
	end
end

function Engine:handleDownPressed()
	for i = #Engine.inputHandlers, 1, -1 do
		local inputHandler = Engine.inputHandlers[i]
		if inputHandler:handleDownPressed() == true then
			return true
		end
	end
end

function Engine:handleLeftPressed()
	for i = #Engine.inputHandlers, 1, -1 do
		local inputHandler = Engine.inputHandlers[i]
		if inputHandler:handleLeftPressed() == true then
			return true
		end
	end
end

function Engine:handleRightPressed()
	for i = #Engine.inputHandlers, 1, -1 do
		local inputHandler = Engine.inputHandlers[i]
		if inputHandler:handleRightPressed() == true then
			return true
		end
	end
end

function Engine:handleAPressed()
	for i = #Engine.inputHandlers, 1, -1 do
		local inputHandler = Engine.inputHandlers[i]
		if inputHandler:handleAPressed() == true then
			return true
		end
	end
end

function Engine:handleBPressed()
	for i = #Engine.inputHandlers, 1, -1 do
		local inputHandler = Engine.inputHandlers[i]
		if inputHandler:handleBPressed() == true then
			return true
		end
	end
end

function Engine:addDrawable(drawable)
	-- If this assert fires, then you are attempting to add a drawable that doesn't implement the draw function
	assert(drawable ~= nil)
	assert(drawable.draw)

	local next = #Engine.drawables + 1
	Engine.drawables[next] = drawable
	drawable:didAddToParent()
end

function Engine:removeDrawable(drawable)
	assert(drawable ~= nil)

	for i = 1, #Engine.drawables do
		if Engine.drawables[i] == drawable then
			table.remove(Engine.drawables, i)
			return
		end
	end
end


function Engine:gameLoop()
	playdate.timer.updateTimers()
	Dispatch:process()
	Engine:redraw()
end

function Engine:redraw()
	playdate.graphics.setColor(playdate.graphics.kColorBlack)
	playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeNXOR)

	local needsRedraw = false
	for i = 1,#Engine.drawables do
	   local object = Engine.drawables[i]
	   if object.draw ~= nil then
		   if (object:isHidden() == false and object:needsRedraw()) or needsRedraw then
			   --playdate.graphics.clear(playdate.graphics.kColorBlack)
			   needsRedraw = true
			   object:requestRedraw()
			   object:prepareToDraw()
			   object:draw()
			   object:finishDraw()
		   end
	   end
	end
end


function playdate.update()
	Engine:gameLoop()
end

function playdate.upButtonUp()
   Engine:handleUpPressed()
end

function playdate.downButtonUp()
   Engine:handleDownPressed()
end

function playdate.leftButtonUp()
   Engine:handleLeftPressed()
end

function playdate.rightButtonUp()
   Engine:handleRightPressed()
end


function playdate.AButtonUp()
   Engine:handleAPressed()
end

function playdate.BButtonUp()
   Engine:handleBPressed()
end
