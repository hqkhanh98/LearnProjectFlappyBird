-----------------------------------------------------------------------------------------
-- Name Project: Remake Flappy Bird
-- main.lua
-- Author: Huynh Quoc Khanh
-- Version: v0.1
-- Date Create: 07/06/2019
-----------------------------------------------------------------------------------------
-- Start Init --
local background
local introStart
local land
local bird
local pointX = display.contentCenterX
local pointY = display.contentCenterY

-- Set up display group
local backGroup = display.newGroup()
local introGroup = display.newGroup()
local mainGroup = display.newGroup()
-- Configure sheet
local options =
{
     width = 70,
     height = 50,
     numFrames = 4,
     sheetContentWidth = 280,  -- width of original 1x size of entire sheet
     sheetContentHeight = 50  -- height of original 1x size of entire sheet
}

-- End Init --

-- Set physical
local physics = require "physics"
physics.start()
physics.setGravity( 0, 0.3 )

-- Set display background game
background = display.newImageRect( backGroup, "Assets/Images/background-night.png", 768, 1024 )
background.x = pointX
background.y = pointY

-- Set display intro tab for start game
introStart = display.newImageRect( introGroup, "Assets/Images/go.png", 394, 512 )
introStart.x = pointX
introStart.y = pointY - 100

-- Set display land
land = display.newImageRect( mainGroup, "Assets/Images/land.png", 640, 213 )
land.x = pointX
land.y = display.contentHeight - 50
physics.addBody( land, "static", {bounce=0})

-- The function create the animation of bird and add physics into it.
local function setUpDisPlayAndPhysicsBird()
    -- Set display and add physics for bird
    local birdSheet = graphics.newImageSheet( "Assets/Images/bird.png", options )
    -- bird = display.newImageRect( mainGroup, sheetOptions, 70, 50   )
    local sequenceData =
    {
      name="fly",
      start=1,
      count=3,
      time=300,
      loopCount = 0,
      loopDirection = "forward"
    }

    bird = display.newSprite( mainGroup, birdSheet, sequenceData )
    bird.x = pointX
    bird.y = pointY
    physics.addBody( bird, "dynamic", { radius=17, bounce=0 } )
    --brid.alpha = 0
    --bird:setSequence( "fly" )
    bird:play()
    bird.rotation = 0
end-- End function setUpDisPlayAndPhysicsBird --



-- Function tab for start game
local function hideIntroStart()
  introStart.alpha = 0
  setUpDisPlayAndPhysicsBird()
end -- end hideIntroStart

introStart:addEventListener( "tap", hideIntroStart )

function testTab()
  print("test")
end

background:addEventListener( "tab", testTab )
