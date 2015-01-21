-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )



do
   local valid, loader = pcall(require, "social."..system.getInfo("platformName"):gsub("%s", "_"))
     if valid then
       social = loader
     else
       social = {loaded = false}
     end
end

-- Set the audio mix mode to allow sounds from the app to mix with other sounds from the device
  if audio.supportsSessionProperty == true then
      print("supportsSessionProperty is true")
            audio.setSessionProperty(audio.MixMode, audio.AmbientMixMode)
  end

  -- Store whether other audio is playing.  It's important to do this once and store the result now,
        -- as referring to audio.OtherAudioIsPlaying later gives misleading results, since at that point
        -- the app itself may be playing audio
  isOtherAudioPlaying = false

  if audio.supportsSessionProperty == true then
      print("supportsSessionProperty is true")
            if not(audio.getSessionProperty(audio.OtherAudioIsPlaying) == 0) then
            print("I think there is other Audio Playing")
                isOtherAudioPlaying = true
            end
  end

local gameNetwork = require "gameNetwork"
local status = {}

local function register( event )
	if event.type == 'init' then status.loaded = event.data
	end
end

local function loader(event)
     if event.type == 'applicationStart' then
       gameNetwork.init("gamecenter", register)
       Runtime:removeEventListener('system', loader)
	end
end

-- include the Corona "storyboard" module
local storyboard = require "storyboard"

Runtime:addEventListener('system', loader)


-- load menu screen


storyboard.gotoScene( "splash" )
