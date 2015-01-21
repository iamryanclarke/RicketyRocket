local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

----------------------------------------------------------------------------------
--
--      NOTE:
--
--      Code outside of listener functions (below) will only be executed once,
--      unless storyboard.removeScene() is called.
--
---------------------------------------------------------------------------------
-- include Corona's library
local widget = require "widget"
local physics = require "physics"
local physicsData

local gameNetwork = require "gameNetwork"






--highscores
local highScoreText
local highScore
local currentScoreText
local gameoverText


-- forward declarations and other locals
local filter
local busUnlock = 0
local playBtn
local menuBtn
local leaderboardBtn
local _W = display.contentWidth;
local _H = display.contentHeight;
local earth
local background
local hero
local heroSequence
local heroData
local heroSheet
local sun
local fuelBar
local roof
local earthSpeed = -0.4
local sunSpeed = 0.4
local gravityLevel = 1.8
local speed = 5
local inEvent = 0
local scoreCount = 0
local event
local cellEvent
local collisionRect
local scoreText
local gate1
local gate2
local gate3
local gate4
local gate5
local gate6
local gate7
local gate8
local cell1
local cell2
local cell3
local stratos
local stratosScale = 1.5
local stratosGrow = true
local fuelSound = audio.loadSound( "audio/coin.wav" )
local hitSound = audio.loadSound( "audio/hit.mp3" )
--local thrustSound = audio.loadSound( "audio/thrust.m4a" )




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


-- 'onRelease' event listener for playBtn
local function onGameOver()
	print("Reloading.lua")
	gameNetwork.request( "setHighScore",
	{
    	localPlayerScore = { category = "Rickety_RocketLeader_Board", value = scoreCount },
	})
	storyboard.gotoScene( "reloading", "fade", 500 )
	return true	-- indicates successful touch
end

local function gotoMenu()
	print("Going to Menu")
	gameNetwork.request( "setHighScore",
	{
    	localPlayerScore = { category = "Rickety_RocketLeader_Board", value = scoreCount },
	})
	storyboard.gotoScene( "menu", "fade", 500 )
	return true	-- indicates successful touch
end


--Funtions

local function updateHero()
	hero.gravityScale = gravityLevel
	if(hero.isAlive == true) then
		if(hero.accel > 0) then
			hero.accel = hero.accel - 2
		end
		hero.y = hero.y - hero.accel
		hero.y = hero.y - hero.gravity
	else
		--died action
	end
	--update the collisionRect to stay in front of the hero
	collisionRect.y = hero.y
end

local function touched( event )
	if(hero.isAlive == true) then
		--audio.play( thrustSound )
		if(event.phase == "began") then
			if(event.x < _W) then
				hero.accel = hero.accel + 30
				 --hero:setSequence("jumping") change sequence
			end
		end
	end
end

local function checkCollisions()
	if ( hero.y < -100 ) then
		hero.accel = hero.accel - 8
	end
	if (hero.x < -50 or hero.x > _W + 50 or hero.y > _H) then
		hero.isAlive = false
		if scoreCount > highScore then
      		highScore = scoreCount
      		print("New Highscore: " ..highScore)
      		local highScoreFilename = "highScore.data"
      		saveValue( highScoreFilename, tostring(highScore) )

    	end
    	gameoverPopup.alpha = 1
    	gameoverText.text = "You Crashed :("
		  gameoverText.x = _W / 2
		  gameoverText.y = (_H / 2) - 300
      currentScoreText.text = "Score: " ..scoreCount
      currentScoreText.x = _W / 2
      currentScoreText.y = (_H / 2) - 200

      highScoreText.text = "Best: " ..highScore
		  highScoreText.x = _W / 2
		  highScoreText.y = (_H / 2) - 100
		  playBtn.x = (_W / 2) + 100
		  playBtn.y = (_H / 2) + 25

		  menuBtn.x = (_W / 2) - 100
		  menuBtn.y = (_H / 2) + 25


		  leaderboardBtn.x = _W / 2
		  leaderboardBtn.y = (_H / 2) + 170

		--endGameTimer = timer.performWithDelay( 2000, onGameOver)
	end
end

local function updateStratos()
	if ( stratosScale <= 1.4 ) then
		stratosGrow = true
	end
	if ( stratosScale >= 1.6 ) then
		stratosGrow = false
	end
	if (stratosGrow == true) then
		stratosScale = stratosScale + 0.0015
	else
		stratosScale = stratosScale - 0.0015
	end
	stratos.xScale = stratosScale
	stratos.yScale = stratosScale
end

local function hasCollectedFuel()
   if ( cell1.isAlive == true and hero.isAlive == true ) then  --make sure the other object exists
	   local dx = hero.x - cell1.x
	   local dy = hero.y - cell1.y

	   local distance = math.abs(math.sqrt( dx*dx + dy*dy ))
	   local objectSize = 100

	   if ( distance <= objectSize ) then
	   		audio.play( fuelSound )
		    fuelLife.x = _W / 2
			fuelLife.y = 100
			fuelLife.width = 500
	    	cell1.isAlive = false
	    	cell1.x = _H + 300
	   end
	end
	if ( cell2.isAlive == true and hero.isAlive == true ) then  --make sure the other object exists
	   local dx = hero.x - cell2.x
	   local dy = hero.y - cell2.y

	   local distance = math.abs(math.sqrt( dx*dx + dy*dy ))
	   local objectSize = 100

	   if ( distance <= objectSize ) then
	   		audio.play( fuelSound )
		    fuelLife.x = _W / 2
			fuelLife.y = 100
			fuelLife.width = 500
	    	cell2.isAlive = false
	    	cell2.x = _H + 300
	   end
	end
	if ( cell3.isAlive == true and hero.isAlive == true ) then  --make sure the other object exists
	   local dx = hero.x - cell3.x
	   local dy = hero.y - cell3.y

	   local distance = math.abs(math.sqrt( dx*dx + dy*dy ))
	   local objectSize = 100

	   if ( distance <= objectSize ) then
	   		audio.play( fuelSound )
		    fuelLife.x = _W / 2
			fuelLife.y = 100
			fuelLife.width = 500
	    	cell3.isAlive = false
	    	cell3.x = _H + 300
	   end
	end
end


local function onCollision( event )
        if ( event.phase == "began" ) then

                --print( "hit something" )

        elseif ( event.phase == "ended" ) then
        	audio.play( hitSound )

                --print( "ending hitting something" )

        end
end

local function updateScore()
	if (hero.isAlive == true) then
		scoreCount = scoreCount + 1
		scoreText.text = scoreCount
		scoreText.x = _W / 2
		scoreText.y = _H - 80
	end
end


local function updateFuel()
	if (hero.isAlive == true) then
		fuelLife.width = fuelLife.width - 40
		fuelLife.x = fuelLife.x - 20
		print(fuelLife.width)
		if (fuelLife.width <= 20) then
			hero.isAlive = false
		end
	end
end

local function createFuel()
	cellEvent = math.random(3)
	if (cellEvent == 0 or cellEvent == 1) then
		cell1.isAlive = true
	end
	if (cellEvent == 2) then
		cell2.isAlive = true
	end
	if (cellEvent == 3) then
		cell3.isAlive = true
	end
end

local function makeAlive()
		event = math.random(12)
		if (event == 1) then
			gate1.isAlive = true
		end
		if (event == 2) then
			gate2.isAlive = true
		end
		if (event == 3) then
			gate3.isAlive = true
		end
		if (event == 4) then
			gate4.isAlive = true
		end
		if (event == 5) then
			gate5.isAlive = true
		end
		if (event == 6) then
			gate6.isAlive = true
		end
		if (event == 7) then
			gate7.isAlive = true
		end
		if (event == 8) then
			gate8.isAlive = true
		end
		if (event == 9) then
			gate9.isAlive = true
		end
		if (event == 10) then
			gate10.isAlive = true
		end
		if (event == 11) then
			gate11.isAlive = true
		end
		if (event == 12) then
			gate12.isAlive = true
		end
	end

local function updateGate()
	if(gate1.isAlive == true) then
		if (gate1.x < -200) then
			gate1.x = _W + 300
			gate1.isAlive = false
		end
		gate1.x = gate1.x - 14
		gate1.y = _H / 11
		gate1:rotate(-1.1)
	else
		--died action
	end
	if(gate2.isAlive == true) then
		if (gate2.x < -200) then
			gate2.x = _W + 300
			gate2.isAlive = false
		end
		gate2.x = gate2.x - 14
		gate2.y = (_H / 11) * 2
		gate2:rotate(-1.8)
	else
		--died action
	end

	if(gate3.isAlive == true) then
		if (gate3.x < -200) then
			gate3.x = _W + 300
			gate3.isAlive = false
		end
		gate3.x = gate3.x - 14
		gate3.y = (_H / 11) * 3
		gate3:rotate(-3.3)
	else
		--died action
	end

	if(gate4.isAlive == true) then
		if (gate4.x < -200) then
			gate4.x = _W + 300
			gate4.isAlive = false
		end
		gate4.x = gate4.x - 14
		gate4.y = (_H / 11) * 4
		gate4:rotate(-2.8)
	else
		--died action
	end

	if(gate5.isAlive == true) then
		if (gate5.x < -200) then
			gate5.x = _W + 300
			gate5.isAlive = false
		end
		gate5.x = gate5.x - 14
		gate5.y = (_H / 11) * 5
		gate5:rotate(-2.1)
	else
		--died action
	end

	if(gate6.isAlive == true) then
		if (gate6.x < -200) then
			gate6.x = _W + 300
			gate6.isAlive = false
		end
		gate6.x = gate6.x - 14
		gate6.y = (_H / 11) * 6
		gate6:rotate(-1.1)
	else
		--died action
	end

	if(gate7.isAlive == true) then
		if (gate7.x < -200) then
			gate7.x = _W + 300
			gate7.isAlive = false
		end
		gate7.x = gate7.x - 14
		gate7.y = (_H / 11) * 7
		gate7:rotate(-1.5)
	else
		--died action
	end
	if(gate8.isAlive == true) then --large top
		if (gate8.x < -200) then
			gate8.x = _W + 300
			gate8.isAlive = false
		end
		gate8.x = gate8.x - 12
		gate8.y = (_H / 2) - 350
		gate8:rotate(-2.1)
	else
		--died action
	end
	if(gate9.isAlive == true) then --large bottom
		if (gate9.x < -200) then
			gate9.x = _W + 300
			gate9.isAlive = false
		end
		gate9.x = gate9.x - 12
		gate9.y = (_H / 2) + 150
		gate9:rotate(-1.1)
	else
		--died action
	end
	if(gate10.isAlive == true) then
		if (gate10.x < -200) then
			gate10.x = _W + 300
			gate10.isAlive = false
		end
		gate10.x = gate10.x - 19
		gate10.y = _H / 6
		gate10:rotate(-2.4)
	else
		--died action
	end
	if(gate11.isAlive == true) then
		if (gate11.x < -200) then
			gate11.x = _W + 300
			gate11.isAlive = false
		end
		gate11.x = gate11.x - 19
		gate11.y = (_H / 6) * 2
		gate11:rotate(-4.4)
	else
		--died action
	end
	if(gate12.isAlive == true) then
		if (gate12.x < -200) then
			gate12.x = _W + 300
			gate12.isAlive = false
		end
		gate12.x = gate12.x - 19
		gate12.y = (_H / 6) * 3
		gate12:rotate(-1.2)
	else
		--died action
	end
	if(cell1.isAlive == true) then
		if (cell1.x < -200) then
			cell1.x = _W + 300
			cell1.isAlive = false
		end
		cell1.x = cell1.x - 11
		cell1.y = _H / 5
	else
		--died action
	end
	if(cell2.isAlive == true) then
		if (cell2.x < -200) then
			cell2.x = _W + 300
			cell2.isAlive = false
		end
		cell2.x = cell2.x - 11
		cell2.y = (_H / 5) * 2
	else
		--died action
	end

	if(cell3.isAlive == true) then
		if (cell3.x < -200) then
			cell3.x = _W + 300
			cell3.isAlive = false
		end
		cell3.x = cell3.x - 11
		cell3.y = (_H / 5) * 3
	else
		--died action
	end
end


local function update()
	earth:rotate( earthSpeed )
	updateHero()
	updateStratos()
	hasCollectedFuel()
	updateGate()
	checkCollisions()
	--updateBackground()
end



---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
        local group = self.view
        --carrot.init("669967946375073", "5e4ba0e664d3298934a2b89ffa0ed9d0")

        storyboard.removeScene("menu")
        storyboard.removeScene("tutorial")
        storyboard.removeScene("reloading")


        physicsData = (require "shapedefs").physicsData(1.0)
        display.setDefault( "background", 1, 1, 1)


        local highScoreFilename = "highScore.data"
      	local loadedHighScore = loadValue( highScoreFilename )
      	highScore = tonumber(loadedHighScore)
      	print("Current Score: " ..highScore)

      	--high score
		highScoreText = display.newText("High Score: " ..highScore, 0, 0, "GROBOLD", 65)
		highScoreText:setFillColor( 0, 0, 0 )
		highScoreText.x = _W * 2
		highScoreText.y = _H * 2

		--game over caption
		gameoverText = display.newText("You Crashed :(", 0, 0, "GROBOLD", 80)
		gameoverText:setFillColor( 0, 0, 0 )
		gameoverText.x = _W * 2
		gameoverText.y = _H * 2

		--high score
		currentScoreText = display.newText("Score: " ..scoreCount, 0, 0, "GROBOLD", 65)
		currentScoreText:setFillColor( 0, 0, 0 )
		currentScoreText.x = _W * 2
		currentScoreText.y = _H * 2



		playBtn = widget.newButton
		{
		   	width = 200,
		   	height = 150,
		    defaultFile = "images/replay.png",
		    onEvent = onGameOver
		}


		playBtn.x = _W * 2
		playBtn.y = _H * 2



		menuBtn = widget.newButton
		{
		    width = 200,
		   	height = 150,
		    defaultFile = "images/home.png",
		    onEvent = gotoMenu
		}

		menuBtn.x = _W * 2
		menuBtn.y = _H * 2


		leaderboardBtn = widget.newButton
		{
		    width = 400,
		   	height = 150,
		    defaultFile = "images/leaderboard.png",
		    onEvent = leaderboard
		}

		leaderboardBtn.x = _W * 2
		leaderboardBtn.y = _H * 2

		--earth
		earth = display.newImage("images/earth.png")
		earth.width = 1350
		earth.height = 1350
		earth.y = _H + 240
		earth.x = _W / 2
		earth.alpha = 0.90


    --game over pop up
    filter = display.newImage("images/filter.png")
    filter.x = _W / 2
    filter.y = _H / 2
    filter.width = _W
    filter.height = _H
    filter.alpha = 0



		--game over pop up
		gameoverPopup = display.newImage("images/gameover.png")
		gameoverPopup.x = _W / 2
		gameoverPopup.y = _H / 2
		gameoverPopup.width = _W
		gameoverPopup.height = _H
		gameoverPopup.alpha = 0

		--stratos
		stratos = display.newImage("images/stratos.png")
		stratos.xScale = stratosScale
		stratos.yScale = stratosScale
		stratos.y = _H + 240
		stratos.x = _W / 2
		stratos.alpha = 0.1


		--hero
		heroData = { width=100, height=176, numFrames=2, sheetContentWidth=200, sheetContentHeight=176 }
		heroSheet = graphics.newImageSheet( "images/heroSheet.png", heroData )
		--physics.addBody( heroSheet, { density=3.0, friction=0.5, bounce=0.3 } )
		heroSequence = {
		{ name = "run", start=1, count=2, time=150 },
		{ name = "dead", frames={ 2, 2 }, loopCount=1 },
	 	}
		hero = display.newSprite( heroSheet, heroSequence )
		hero.x = (_W / 2)
		hero.y = _H / 2
		hero.xScale = 0.7
		hero.yScale = 0.7
		hero:rotate( 90 )
		hero.gravity = -5
		hero.accel = 30
		hero.width = 70
		hero.height = 123
		hero.isAlive = true
		hero:setSequence("run")
		hero:play()

		 --fuel bar
		fuelBar = display.newImage("images/lifeBar.png")
        fuelBar.x = _W / 2
		fuelBar.y = 100
		fuelBar.width = 500
		fuelBar.height = 50

		fuelLife = display.newImage("images/lifeReduce.png")
        fuelLife.x = _W / 2
		fuelLife.y = 100
		fuelLife.width = 500
		fuelLife.height = 50
		fuelLife.alpha = 0.90

		--collision rect
		collisionRect = display.newRect(hero.x + 15, 100, 1, 100)
		collisionRect.strokeWidth = 1
		collisionRect:setFillColor(140, 140, 140)
		collisionRect:setStrokeColor(180, 180, 180)
		collisionRect.alpha = 0

		--Fuel Cells
		cell1 = display.newImage("images/cell.png")
		cell1.x = _W + 2
		cell1.y = _H * 2
		cell1.anchorX = 0
		cell1.anchorY = 0
		cell1.width = 95
		cell1.height = 95
		cell1.isAlive = false

		cell2 = display.newImage("images/cell.png")
		cell2.x = _W + 2
		cell2.y = _H * 2
		cell2.anchorX = 0
		cell2.anchorY = 0
		cell2.width = 95
		cell2.height = 95
		cell2.isAlive = false

		cell3 = display.newImage("images/cell.png")
		cell3.x = _W + 2
		cell3.y = _H * 2
		cell3.anchorX = 0
		cell3.anchorY = 0
		cell3.width = 95
		cell3.height = 95
		cell3.isAlive = false

		--gate1
		gate1 = display.newImage("images/gate.png")
		gate1.x = _W + 2
		gate1.y = _H * 2
		gate1.anchorX = 0
		gate1.anchorY = 0
		gate1.width = 95
		gate1.height = 95
		gate1.isAlive = false

		--gate2
		gate2 = display.newImage("images/gate.png")
		gate2.x = _W + 2
		gate2.y = _H * 2
		gate2.anchorX = 0
		gate2.anchorY = 0
		gate2.width = 95
		gate2.height = 95
		gate2.isAlive = false

		--gate3
		gate3 = display.newImage("images/gate.png")
		gate3.x = _W + 2
		gate3.y = _H * 2
		gate3.anchorX = 0
		gate3.anchorY = 0
		gate3.width = 95
		gate3.height = 95
		gate3.isAlive = false

		--gate4
		gate4 = display.newImage("images/gate.png")
		gate4.x = _W + 2
		gate4.y = _H * 2
		gate4.anchorX = 0
		gate4.anchorY = 0
		gate4.width = 95
		gate4.height = 95
		gate4.isAlive = false

		--gate5
		gate5 = display.newImage("images/gate.png")
		gate5.x = _W + 2
		gate5.y = _H * 2
		gate5.anchorX = 0
		gate5.anchorY = 0
		gate5.width = 95
		gate5.height = 95
		gate5.isAlive = false

		--gate6
		gate6 = display.newImage("images/gate.png")
		gate6.x = _W + 2
		gate6.y = _H * 2
		gate6.anchorX = 0
		gate6.anchorY = 0
		gate6.width = 95
		gate6.height = 95
		gate6.isAlive = false

		--gate7
		gate7 = display.newImage("images/gate.png")
		gate7.x = _W + 2
		gate7.y = _H * 2
		gate7.anchorX = 0
		gate7.anchorY = 0
		gate7.width = 95
		gate7.height = 95
		gate7.isAlive = false

		--gate8
		gate8 = display.newImage("images/gate.png")
		gate8.x = _W + 2
		gate8.y = _H * 2
		gate8.anchorX = 0
		gate8.anchorY = 0
		gate8.width = 140
		gate8.height = 140
		gate8.isAlive = false

		--gate9
		gate9 = display.newImage("images/gate.png")
		gate9.x = _W + 2
		gate9.y = _H * 2
		gate9.anchorX = 0
		gate9.anchorY = 0
		gate9.width = 140
		gate9.height = 140
		gate9.isAlive = false

		--gate10
		gate10 = display.newImage("images/gate3.png")
		gate10.x = _W + 2
		gate10.y = _H * 2
		gate10.anchorX = 0
		gate10.anchorY = 0
		gate10.width = 60
		gate10.height = 60
		gate10.isAlive = false

		--gate11
		gate11 = display.newImage("images/gate3.png")
		gate11.x = _W + 2
		gate11.y = _H * 2
		gate11.anchorX = 0
		gate11.anchorY = 0
		gate11.width = 60
		gate11.height = 60
		gate11.isAlive = false

		--gate12
		gate12 = display.newImage("images/gate3.png")
		gate12.x = _W + 2
		gate12.y = _H * 2
		gate12.anchorX = 0
		gate12.anchorY = 0
		gate12.width = 60
		gate12.height = 60
		gate12.isAlive = false

		--score
		scoreText = display.newText(scoreCount, 0, 0, "GROBOLD", 70)
		scoreText:setFillColor( 255, 255, 255 )
		scoreText.x = _W / 2
		scoreText.y = _H - 90


		-- all display objects must be inserted into group
		group:insert( stratos )
		group:insert( earth )
		group:insert( fuelLife )
		group:insert( fuelBar )
		group:insert( hero )
		group:insert( gate8 )
		group:insert( gate9 )
		group:insert( cell1 )
		group:insert( cell2 )
		group:insert( cell3 )
		group:insert( gate1 )
		group:insert( gate2 )
		group:insert( gate3 )
		group:insert( gate4 )
		group:insert( gate5 )
		group:insert( gate6 )
		group:insert( gate7 )
		group:insert( gate10 )
		group:insert( gate11 )
		group:insert( gate12 )
		group:insert( collisionRect )
		group:insert( scoreText )
		group:insert( gameoverPopup )
		group:insert( playBtn )
		group:insert( menuBtn )
		group:insert( leaderboardBtn )
		group:insert( highScoreText )
    group:insert( filter )


        -----------------------------------------------------------------------------

        --      CREATE display objects and add them to 'group' here.
        --      Example use-case: Restore 'group' from previously saved state.

        -----------------------------------------------------------------------------

end

-- Called BEFORE scene has moved onscreen:
function scene:willEnterScene( event )
        local group = self.view
     	physics.start()
     	print("Physics Started")
        physics.addBody( earth, "static", physicsData:get("earth") )
        physics.addBody( hero, "dynamic", physicsData:get("hero") )
        physics.addBody( gate1, "static", {radius=40, density=10, friction=0.3, bounce=0}  )
        physics.addBody( gate2, "static", {radius=40, density=10, friction=0.3, bounce=0}  )
        physics.addBody( gate3, "static", {radius=40, density=10, friction=0.3, bounce=0}  )
        physics.addBody( gate4, "static", {radius=40, density=10, friction=0.3, bounce=0}  )
        physics.addBody( gate5, "static", {radius=40, density=10, friction=0.3, bounce=0}  )
        physics.addBody( gate6, "static", {radius=40, density=10, friction=0.3, bounce=0}  )
        physics.addBody( gate7, "static", {radius=40, density=10, friction=0.3, bounce=0}  )
        physics.addBody( gate8, "static", {radius=65, density=10, friction=0.3, bounce=0}  )
        physics.addBody( gate9, "static", {radius=65, density=10, friction=0.3, bounce=0}  )
        physics.addBody( gate10, "static", {radius=28, density=10, friction=0.3, bounce=0}  )
        physics.addBody( gate11, "static", {radius=28, density=10, friction=0.3, bounce=0}  )
        physics.addBody( gate12, "static", {radius=28, density=10, friction=0.3, bounce=0}  )

        -----------------------------------------------------------------------------

        --      This event requires build 2012.782 or later.

        -----------------------------------------------------------------------------

end



-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
        local group = self.view

       -----------------------------------------------------------------------------

        --      INSERT code here (e.g. start timers, load audio, start listeners, etc.)

        -----------------------------------------------------------------------------
        GodTimer = timer.performWithDelay(15, update, -1)
        FuelTimer = timer.performWithDelay(1000, updateFuel, -1)
        createFuelTimer = timer.performWithDelay(4500, createFuel, -1)
        Runtime:addEventListener("touch", touched, -1)
        Runtime:addEventListener( "collision", onCollision )
        MakeAliveTimer = timer.performWithDelay(500, makeAlive, -1)
        ScoreTimer = timer.performWithDelay(1000, updateScore, -1)
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
        local group = self.view

        timer.cancel( GodTimer )
        timer.cancel( ScoreTimer )
        timer.cancel( MakeAliveTimer )
        timer.cancel( FuelTimer )
        timer.cancel( createFuelTimer )
        --timer.cancel( endGameTimer )
        Runtime:removeEventListener("touch", touched)
        Runtime:removeEventListener("collision", onCollision)

        physics.removeBody(earth)
        display.remove(earth)
        earth = nil

        physics.removeBody(gate1)
        display.remove(gate1)
        gate1 = nil

        physics.removeBody(gate2)
        display.remove(gate2)
        gate2 = nil

        physics.removeBody(gate3)
        display.remove(gate3)
        gate3 = nil

        physics.removeBody(gate4)
        display.remove(gate4)
        gate4 = nil

        physics.removeBody(gate5)
        display.remove(gate5)
        gate5 = nil

        physics.removeBody(gate6)
        display.remove(gate6)
        gate6 = nil

        physics.removeBody(gate7)
        display.remove(gate7)
        gate7 = nil

        physics.removeBody(gate8)
        display.remove(gate8)
        gate8 = nil

        physics.removeBody(gate9)
        display.remove(gate9)
        gate9 = nil

        physics.removeBody(gate10)
        display.remove(gate10)
        gate10 = nil

        physics.removeBody(gate11)
        display.remove(gate11)
        gate11 = nil

        physics.removeBody(gate12)
        display.remove(gate12)
        gate12 = nil

        physics.removeBody(hero)
        display.remove(hero)
        hero = nil

        display.remove(fuelBar)
        fuelBar = nil

        display.remove(fuelLife)
        fuelLife = nil

        display.remove(cell1)
        cell1 = nil

        display.remove(cell2)
        cell2 = nil

        display.remove(cell3)
        cell3 = nil

        display.remove(stratos)
        stratos = nil

        display.remove(gameoverPopup)
        gameoverPopup = nil

        display.remove(scoreText)
        scoreText = nil

        display.remove(currentScoreText)
        currentScoreText = nil

        display.remove(gameoverText)
        gameoverText = nil

        display.remove(filter)
        filter = nil




        --kill the sound
        audio.dispose(fuelSound)
        audio.dispose(hitSound)
        --audio.dispose(thrustSound)



        display.remove(highScoreText)
        highScoreText = nil
        print("physics stopped")
        physics.stop()

        -----------------------------------------------------------------------------

        --      INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)

        -----------------------------------------------------------------------------

end


-- Called AFTER scene has finished moving offscreen:
function scene:didExitScene( event )
        local group = self.view

        -----------------------------------------------------------------------------

        --      This event requires build 2012.782 or later.

        -----------------------------------------------------------------------------

end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
        local group = self.view

        if playBtn then
			playBtn:removeSelf()	-- widgets must be manually removed
			playBtn = nil
		end

		if menuBtn then
			menuBtn:removeSelf()	-- widgets must be manually removed
			menuBtn = nil
		end

		if twitterBtn then
			twitterBtn:removeSelf()	-- widgets must be manually removed
			twitterBtn = nil
		end

		if leaderboardBtn then
			leaderboardBtn:removeSelf()	-- widgets must be manually removed
			leaderboardBtn = nil
		end

        package.loaded[physics] = nil
		physics = nil


        -----------------------------------------------------------------------------

        --      INSERT code here (e.g. remove listeners, widgets, save state, etc.)

        -----------------------------------------------------------------------------

end


-- Called if/when overlay scene is displayed via storyboard.showOverlay()
function scene:overlayBegan( event )
        local group = self.view
        local overlay_name = event.sceneName  -- name of the overlay scene

        -----------------------------------------------------------------------------

        --      This event requires build 2012.797 or later.

        -----------------------------------------------------------------------------

end


-- Called if/when overlay scene is hidden/removed via storyboard.hideOverlay()
function scene:overlayEnded( event )
        local group = self.view
        local overlay_name = event.sceneName  -- name of the overlay scene

        -----------------------------------------------------------------------------

        --      This event requires build 2012.797 or later.

        -----------------------------------------------------------------------------

end



---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "willEnterScene" event is dispatched before scene transition begins
scene:addEventListener( "willEnterScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "didExitScene" event is dispatched after scene has finished transitioning out
scene:addEventListener( "didExitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-- "overlayBegan" event is dispatched when an overlay scene is shown
scene:addEventListener( "overlayBegan", scene )

-- "overlayEnded" event is dispatched when an overlay scene is hidden/removed
scene:addEventListener( "overlayEnded", scene )

---------------------------------------------------------------------------------

return scene