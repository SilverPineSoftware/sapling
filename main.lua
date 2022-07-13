import 'sapling'


function main()

   -- View is the primary "container" mechanism. You can manually construct other Drawables and add them to the Engine object
   -- yourself, but View manages the entire hierarchy, including input handling in a much cleaner way with subviews.
   local view = View()

   -- The ImageView and TextView class are the primary Drawables that you will use.
   local imageView = ImageView("resources/silverpinelogo.png")
   view:add(imageView)
   view:setActive(true)

   -- A few more complex widgets exist, however such as the TypewriterText, the VerticalStackView and the TabSelectView.
   local tabSelectView = TabSelectView()
   tabSelectView:addMenuButton("Show Dialog")
   tabSelectView:addMenuButton("Play Sound")
   tabSelectView:addMenuButton("Change Font")
   view:add(tabSelectView)

   -- Fonts for all widgets are managed through a FontManager class.
   local usingCustomFont = true
   FontManager:setCurrentFont("resources/Sasser-Small-Caps")

   -- Sounds are just handled through the default Playdate sound playback system
   local soundPlayer = playdate.sound.fileplayer.new("resources/background.mp3", 1)

   -- Each Drawable is subclassed from the InputHandler class which provides for pre-defined input handling functions that
   --    can be overridden dynamically. The Engine knows to chain them in reverse order.
   --    Return 'true' from the handler to not let any other handlers receive the input.
   view.handleAPressed = function()
      -- Grab the selection from the TabSelectView
      local index = tabSelectView:selectedItem()

      -- Pop up an Alert
      if index == 1 then
         Alert("Hello world!", "OK")
      end

      -- Toggle the music
      if index == 2 then
         if soundPlayer:isPlaying() then
            soundPlayer:pause()
         else
            soundPlayer:play(0)
         end
      end

      if index == 3 then
         if usingCustomFont then
            usingCustomFont = false
            FontManager:setCurrentFont("resources/Bitmore-Medieval")
         else
            usingCustomFont = true
            FontManager:setCurrentFont("resources/Sasser-Small-Caps")
         end

         view:requestRedraw()
      end

      return true
   end
end


-- Let's GOOOOOOOOOO!!!!!!!
main()

