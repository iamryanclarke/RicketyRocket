-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"
local gameNetwork = require "gameNetwork"



--------------------------------------------

-- forward declarations and other locals
local playBtn
local busBtn
local busBtnOn
local busUnlock
local tutorialBtn
local facebookBtn
local twitterBtn
local facebookBg
local twitterBg
local leaderboardBtn
local ship
local earth
local _W = display.contentWidth;
local _H = display.contentHeight;

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()

	-- go to the game
	storyboard.gotoScene( "game", "fade", 500 )

	return true	-- indicates successful touch
end


local function leaderboard()
	gameNetwork.show('leaderboards',
        {
         leaderboard = {
           category = 'Rickety_RocketLeader_Board',
           timeScope = 'AllTime';
		  };
		}
	)
end

local function gotoFacebook()
	if(not system.openURL("fb://profile/1427097660865794")) then
    	system.openURL("https://www.facebook.com/ricketyrocketapp")
	end
	return true	-- indicates successful touch
end

local function gotoTwitter()
	if(not system.openURL( "twitter://user?screen_name=Rickety_Rocket" )) then
    	system.openURL("https://twitter.com/Rickety_Rocket")
	end
	return true	-- indicates successful touch
end

local function onTutorialBtnRelease()
	storyboard.gotoScene( "flight_test", "fade", 500 )
	return true
end


local function update()
	earth:rotate( -0.4 )
end

	-- Function to handle button events
local function handleButtonEvent( event )

    if ( "ended" == event.phase ) then
        print( "Button was pressed and released" )
    end
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

	-- display a background image


	display.setDefault( "background", 1, 1, 1 )
	storyboard.removeScene("splash")
	storyboard.removeScene("game")
	storyboard.removeScene("tutorial")



	ship = display.newImage("images/rocket.png")
    ship.x = (_W / 4) + 50
	ship.y = 325
	ship.width = 650
	ship.height = 650


	twitterBtn = widget.newButton
	{
		width = _W / 2,
		height = 160,
		defaultFile = "images/twitter.png",
		onEvent = gotoTwitter
	}

	twitterBtn.x = _W / 4
	twitterBtn.y = _H - 80



	facebookBtn = widget.newButton
	{
	    width = _W / 2,
	   	height = 160,
	    defaultFile = "images/facebook.png",
	    onEvent = gotoFacebook
	}

	facebookBtn.x = _W - (_W / 4)
	facebookBtn.y = _H - 80


-- Change the button's label text
--button1:setLabel( "2-Frame" )

	--earth
	earth = display.newImage("images/earth.png")
	earth.width = 1600
	earth.height = 1600
	earth.y = _H - 300
	earth.x = _W / 2
	earth.alpha = 0.15


	playBtn = widget.newButton{
			label="Play",
			font = "GROBOLD",
			fontSize = 70,
			labelColor = { default={0}, over={0} },
			width=154, height=40,
			onRelease = onPlayBtnRelease	-- event listener function
		}
	playBtn.x = _W / 2
	playBtn.y = _H - 500



  	leaderboardBtn = widget.newButton{
			label="Leaderboard",
			font = "GROBOLD",
			fontSize = 70,
			labelColor = { default={0}, over={0} },
			width=154, height=40,
			onRelease = leaderboard	-- event listener function
		}
	leaderboardBtn.x = _W / 2
	leaderboardBtn.y = _H - 400

	tutorialBtn = widget.newButton{
			label="Tutorial",
			font = "GROBOLD",
			fontSize = 70,
			labelColor = { default={0}, over={0} },
			width=154, height=40,
			onRelease = onTutorialBtnRelease	-- event listener function
		}
	tutorialBtn.x = _W / 2
	tutorialBtn.y = _H - 300



	-- all display objects must be inserted into group
	group:insert( earth )
	group:insert( ship )
	group:insert( playBtn )
	group:insert( leaderboardBtn )
	group:insert( tutorialBtn )
	group:insert( facebookBtn )
	group:insert( twitterBtn )
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view

	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	GodTimer = timer.performWithDelay(15, update, -1)
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view

	timer.cancel( GodTimer )

	display.remove(ship)
    ship = nil

    display.remove(earth)
    earth = nil


	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)

end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view

	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end

	if facebookBtn then
		facebookBtn:removeSelf()	-- widgets must be manually removed
		facebookBtn = nil
	end

	if twitterBtn then
		twitterBtn:removeSelf()	-- widgets must be manually removed
		twitterBtn = nil
	end

	if leaderboardBtn then
		leaderboardBtn:removeSelf()	-- widgets must be manually removed
		leaderboardBtn = nil
	end


	if tutorialBtn then
		tutorialBtn:removeSelf()	-- widgets must be manually removed
		tutorialBtn = nil
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
