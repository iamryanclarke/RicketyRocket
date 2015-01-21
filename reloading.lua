-----------------------------------------------------------------------------------------
--
-- removeGame.lua
--
-----------------------------------------------------------------------------------------
display.setStatusBar( display.HiddenStatusBar )


local storyboard = require( "storyboard" )
local RevMob = require('revmob')

local scene = storyboard.newScene()

local timerText
local count
local _W = display.contentWidth;
local _H = display.contentHeight;

local banner
local RevBanner
local earth

local REVMOB_IDS =  {
  ["iPhone OS"] = "53192997b5469caa070bb596"
}




-- include Corona's "widget" library
local widget = require "widget"

-- The name of the ad provider.
local provider = "admob"

-- Your application ID
local appID = "ca-app-pub-4840593550201873/7664755747" --banner ad


-- Load Corona 'ads' library
local ads = require "ads"

local showAd
-- Create a text object to display ad status
local statusText


revmobListener = function (event)
  print("Event: " .. event.type)
  for k,v in pairs(event) do print(tostring(k) .. ': ' .. tostring(v)) end
end




--high scores functions
local saveValue = function( strFilename, strValue )
    -- will save specified value to specified file
    local theFile = strFilename
    local theValue = strValue

    local path = system.pathForFile( theFile, system.DocumentsDirectory )

    -- io.open opens a file at path. returns nil if no file found
    local file = io.open( path, "w+" )
    if file then
       -- write game score to the text file
       file:write( theValue )
       io.close( file )
    end
  end

  local loadValue = function( strFilename )
    -- will load specified file, or create new file if it doesn't exist

    local theFile = strFilename

    local path = system.pathForFile( theFile, system.DocumentsDirectory )

    -- io.open opens a file at path. returns nil if no file found
    local file = io.open( path, "r" )
    if file then
       -- read all contents of file into a string
       local contents = file:read( "*a" )
       io.close( file )
       return contents
    else
       -- create file b/c it doesn't exist yet
       file = io.open( path, "w" )
       file:write( "0" )
       io.close( file )
       return "0"
    end
  end
--end high score values


-- Load Corona 'ads' library
	local function adListener( event )
		if event.isError then
			print("error with ad")
		else
		end
	end

local function update()
	earth:rotate( -0.4 )
end



--------------------------------------------

-- 'onRelease' event listener for playBtn
local function gotoGame()
	ads.hide()
  RevBanner:hide()
	storyboard.gotoScene( "game", "fade", 300 )

	return true	-- indicates successful touch
end

local function timerUpdate()
	count = count - 1
	if (count < 1) then
		restartGame = timer.performWithDelay( 500, gotoGame )
		timerText.text = "Launch"
		timerText.x = _W / 2
		timerText.y = _H - 350
	else
		timerText.text = count
		timerText.x = _W / 2
		timerText.y = _H - 350
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

	RevMob.startSession(REVMOB_IDS)

	local playCountFilename = "playcount.data"
    local loadedPlayCount = loadValue( playCountFilename )
    playCount = tonumber(loadedPlayCount)
    print("Current Play Count: " ..playCount)

    saveValue( playCountFilename, tostring(playCount + 1) )

	display.setDefault( "background", 1, 1, 1 )


	--earth
	earth = display.newImage("images/earth.png")
	earth.width = 1600
	earth.height = 1600
	earth.y = _H - 200
	earth.x = _W / 2
	earth.alpha = 0.15

	if (playCount >= 6) then
		RevMob.showFullscreen()
		saveValue( playCountFilename, tostring(0) )
	end
  
  ads.init( "admob", appID, adListener )
  ads.show( "banner", { x=0, y=0 } )
  RevBanner = RevMob.createBanner({ x = _W / 2, y = _H - 60, width = _W, height = 120 })

	count = 3
	--score
	timerText = display.newText(count, 0, 0, "GROBOLD", 155)
	timerText:setFillColor( 0, 0, 0 )
	timerText.x = _W / 2
	timerText.y = _H - 350
	storyboard.removeScene("game")

	group:insert( earth )

	-- display a background image

end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view


	countTimer = timer.performWithDelay(1000, timerUpdate, -1)
	GodTimer = timer.performWithDelay(15, update, -1)


	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)

end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	timer.cancel( countTimer )
	timer.cancel( restartGame )
	timer.cancel( GodTimer )
	display.remove(timerText)
    timerText = nil

    display.remove(earth)
    earth = nil

	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)

end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view

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
