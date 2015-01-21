-----------------------------------------------------------------------------------------
--
-- tutorial.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"
local background
local homeBtn
local nextBtn
local slide1
local slide2
local slide3
local _H = display.contentHeight;
local _W = display.contentWidth;
local slideCount

--------------------------------------------

-- 'onRelease' event listener for playBtn
local function onHomeBtnRelease()
	storyboard.gotoScene( "menu", "fade", 400 )
	
	return true	-- indicates successful touch
end

local function onNextBtnRelease()
	
	slideCount = slideCount + 1
	if (slideCount > 3) then
		storyboard.gotoScene( "game", "fade", 400 )
	end
	if (slideCount == 2) then
		slide1.alpha = 0
		slide2.alpha  = 1
		slide3.alpha  = 0
	end
	if (slideCount == 3) then
		slide1.alpha = 0
		slide2.alpha  = 0
		slide3.alpha  = 1
		nextBtn:setLabel( "OK, Let's Play!" )
	end
	
	return true	-- indicates successful touch
end

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	storyboard.removeScene("menu")

	-- display a background image
	display.setDefault( "background", 1, 1, 1 )
	slideCount = 1

	slide1 = display.newImage("images/slide1.png")
	slide1.width = _W
	slide1.height = _W
	slide1.x = _W / 2
	slide1.y = (_H / 2) - 150
	slide1.alpha = 1

	slide2 = display.newImage("images/slide2.png")
	slide2.width = _W
	slide2.height = _W
	slide2.x = _W / 2
	slide2.y = (_H / 2) - 150
	slide2.alpha = 0

	slide3 = display.newImage("images/slide3.png")
	slide3.width = _W
	slide3.height = _W
	slide3.x = _W / 2
	slide3.y = (_H / 2) - 150
	slide3.alpha = 0

	homeBtn = widget.newButton{
			label="Menu",
			font = "GROBOLD",
			fontSize = 70,
			labelColor = { default={0}, over={0} },
			width=154, height=40,
			onRelease = onHomeBtnRelease	-- event listener function
		}
	homeBtn.x = _W * 2
	homeBtn.y = _H * 2

	nextBtn = widget.newButton{
			label="OK, Got it",
			font = "GROBOLD",
			fontSize = 90,
			labelColor = { default={0}, over={0.5} },
			width= _W, height=60,
			onRelease = onNextBtnRelease	-- event listener function
		}
	nextBtn.x = _W / 2
	nextBtn.y = _H - 200

	group:insert( slide1 )
	group:insert( slide2 )
	group:insert( slide3 )
	group:insert( homeBtn )
	group:insert( nextBtn )


end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view

	display.remove(slide1)
    slide1 = nil

    display.remove(slide2)
    slide2 = nil

    display.remove(slide3)
    slide3 = nil
	
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view

	if homeBtn then
		homeBtn:removeSelf()	-- widgets must be manually removed
		homeBtn = nil
	end

	if nextBtn then
		nextBtn:removeSelf()	-- widgets must be manually removed
		nextBtn = nil
	end

end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene