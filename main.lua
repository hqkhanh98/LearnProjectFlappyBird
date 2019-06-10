-----------------------------------------------------------------------------------------
-- Name Project: Remake Flappy Bird
-- main.lua
-- Author: Huynh Quoc Khanh
-- Version: v0.1
-- Date Create: 07/06/2019
-----------------------------------------------------------------------------------------

-- Start Init --
local background
local gameReady
local land
local pannel
local medalSilver
local medalGold
local gameOver
local pipeUps
local pipeDowns
local holes
local gameLoopTimer
local createLoopTimer
local scoreText
local btnPlayAgain
local pannelScoreText
local pannelBestScoreText

local tablepipeUps = {}
local tablepipeDowns = {}
local tableHoles = {}

local pointX = display.contentCenterX
local pointY = display.contentCenterY
local yBird = pointX-50
local xBird = pointY-50
local Score = 0
local bestScore = 0
local uBird = -200
local vBird = 0
local wBird = -320
local g = 800
local delta = 0.025
local gameStatus = 0

-- Set up display group
local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local UIGroup = display.newGroup()

-- Set physical
local physics = require "physics"
physics.start()
physics.setGravity( 0, 0 )

-- The random number
math.randomseed( os.time() )
local function setUpDisplayBackGround()
  -- Set display background game
  background = display.newImageRect( backGroup, "Assets/Images/background-night.png", 768, 1024 )
  background.x = pointX
  background.y = pointY
  background.alpha = 0
end

local function setUpDisplayLand()
  -- Set display land
  land = display.newImageRect( mainGroup, "Assets/Images/land.png", 640, 213 )
  land.x = pointX
  land.y = display.contentHeight - 50
  physics.addBody( land, "static", {bounce=0})
  land.myName = "land"
  land.alpha = 0
end

local function setUpDisplayScoreText()
  -- Set display Score
  local options = {
  x= pointX , y= 80 ,
  text="",
  font="Assets/Font/troika.otf",
  fontSize= 40 }

  scoreText = display.newText( options )
  scoreText:setFillColor( 1, 1, 1 )
  scoreText.alpha = 0
end

local function setUpDisplayGameReady()
  -- Set display intro tab for start game
  gameReady = display.newImageRect( mainGroup, "Assets/Images/go.png", 394, 512 )
  gameReady.x = pointX
  gameReady.y = pointY - 100
  gameReady.alpha = 0
end

local function setUpDisplayTitleGameOver()
  titleGameOver = display.newImageRect( UIGroup, "Assets/Images/gameover.png" , 200, 60 )
  titleGameOver.x = pointX
  titleGameOver.y = pointY - 200
  titleGameOver.alpha = 0
end

local function setUpDisplayPannel()
  pannel = display.newImageRect( UIGroup, "Assets/Images/pannel.png", 240, 140 )
  pannel.x = pointX
  pannel.y = pointY - 100
  pannel.alpha = 0
end

local function setUpDisplayBtnPlayAgain()
  btnPlayAgain = display.newImageRect(UIGroup, "Assets/Images/btnReset.png", 112, 66 )
  btnPlayAgain.x = pointX
  btnPlayAgain.y = pointY
  btnPlayAgain.alpha = 0
end

local function setUpDisplayMedalSilver()
  medalSilver = display.newImageRect( UIGroup, "Assets/Images/silver.png", 44, 44 )
  medalSilver.x = pointX - 65
  medalSilver.y = pointY - 95
  medalSilver.alpha = 0
end

local function setUpDisplayMedalGold()
  medalGold = display.newImageRect( UIGroup, "Assets/Images/gold.png", 44, 44 )
  medalGold.x = pointX - 65
  medalGold.y = pointY - 95
  medalGold.alpha = 0
end

local function setUpDisplayPannelScoreText()
  local optionsScore = {
  x= pointX + 75 , y= pointY - 115 ,
  text = Score,
  font="Assets/Font/troika.otf",
  fontSize = 25 }

  pannelScoreText = display.newText( optionsScore )
  pannelScoreText:setFillColor( 1, 0, 0 )
  pannelScoreText.alpha = 0
end

local function setUpDisplayPannelBestScoreText()
  local optionsScore = {
  x= pointX + 75 , y= pointY - 70 ,
  text = bestScore,
  font="Assets/Font/troika.otf",
  fontSize = 25 }

  pannelBestScoreText = display.newText( optionsScore )
  pannelBestScoreText:setFillColor( 1, 0, 0 )
  pannelBestScoreText.alpha = 0
end

local function transitionGame()
  transition.to( pipeUps, { x=0, time=5000 } )
  transition.to( pipeDowns, { x=0, time=5000 } )
  transition.to( holes, { x=0, time=5000 } )
end

local function setUpAndCreatePipe()
  -- The hole between pipeUp and pipeDown
  local rndNumber = math.random(300, 500)
  holes = display.newRect( 0, 0, 0.1, 150 )
  holes.strokeWidth = 1
  holes:setFillColor( 0.5 )
  holes.alpha = 1
  holes:setStrokeColor( 1, 0, 0 )
  holes.x = display.contentWidth
  holes.y = rndNumber
  physics.addBody( holes, "dynamic", {bounce = 0} )
  holes.myName = "holes"
  table.insert( tableHoles, holes )

  -- pipeDown
  pipeDowns = display.newImageRect( mainGroup, "Assets/Images/pipe.png", 52, 512 )
  pipeDowns.x = display.contentWidth
  pipeDowns.y = (rndNumber - 331) + 662 -- Công thức // rnd - (pipe.height/2 + holes.height/2) + pipe.height + holes.height
  pipeDowns:toBack()
  table.insert( tablepipeDowns, pipeDowns )
  physics.addBody( pipeDowns, "static" )
  pipeDowns.myName = "pipeDowns"

  -- pipeUp
  pipeUps = display.newImageRect( mainGroup, "Assets/Images/pipe.png", 52, 512 )
  pipeUps.x = display.contentWidth
  pipeUps.y = (rndNumber + 331) - 662
  pipeUps.rotation = 180
  pipeUps:toBack()
  table.insert( tablepipeDowns, pipeUps )
  physics.addBody( pipeUps, "static" )
  pipeUps.myName = "pipeUps"

  transitionGame()
end


local function setUpSpriteAndPhysicsBird()

  -- Configure sheet
  local options =
  {
       width = 70,
       height = 50,
       numFrames = 4,
       sheetContentWidth = 280,  -- width of original 1x size of entire sheet
       sheetContentHeight = 50  -- height of original 1x size of entire sheet
  }

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

  physics.addBody( bird, "dynamic", { radius=17, bounce=0 } )
  bird.myName = "bird"
end
-- Path for the file to read
local path = system.pathForFile( "myfile.txt", system.DocumentsDirectory )

local function saveBestScore()

  -- Open the file handle
  local file, errorString = io.open( path, "r" )

  if not file then
      -- Error occurred; output the cause
      print( "File error: " .. errorString )
  else
      -- Output lines
      for line in file:lines() do
          bestScore = line
      end
      -- Close the file handle
      io.close( file )
  end

  file = nil
end

local function loadBestScore()
  local file, errorString = io.open( path, "w" )

  if not file then
    print( "File error: " .. errorString )
  else
    if ( Score > bestScore ) then
      bestScore = Score
    end
    io.write( string.format( bestScore ) )
    io.close( file )
  end

  file = nil
end

-- function hide the gameReady
local function tabToPlay()

  setUpSpriteAndPhysicsBird()
  xBird = pointX - 50
  yBird = pointY - 50
  gameReady.alpha = 0
  scoreText.text = Score
  createLoopTimer = timer.performWithDelay( 2000, setUpAndCreatePipe, 0 )
  gameStatus = 1
  -- bird.x = pointX
  -- bird.y = pointY
  -- bird:play()
end

local function tabToFly()
  vBird = wBird
end

local function onCollision( event )
  if ( event.phase == "began" ) then
    local obj_1 = event.object1
    local obj_2 = event.object2
    if ( ( obj_1.myName ==  "bird" and obj_2.myName == "pipeUps" ) or
         ( obj_1.myName == "pipeUps" and obj_2.myName == "bird" ) or
         ( obj_1.myName ==  "bird" and obj_2.myName == "pipeDowns" ) or
         ( obj_1.myName ==  "pipeDowns" and obj_2.myName == "bird" ) or
         ( obj_1.myName ==  "bird" and obj_2.myName == "land" ) or
         ( obj_1.myName ==  "land" and obj_2.myName == "bird" ) ) then
           gameStatus = 2
    elseif ( ( obj_1.myName == "bird" and obj_2.myName == "holes" ) or
             ( obj_1.myName == "holes" and obj_2.myName == "bird" ) ) then
              Score = Score + 1
              for i = #tableHoles, 1, -1 do
                local thisHole = tableHoles[i]
                if ( thisHole == obj_1 or thisHole == obj_2 ) then
                  display.remove( thisHole )
                  table.remove( tableHoles, i )
                end
              end
    end
  end
end

local function clearAll()
  -- Clear obj
    for i = #tableHoles, 1, -1 do
        local thisHole = tableHoles[i]
        display.remove( thisHole )
        table.remove( thisHole, i )
    end
    for i = #tablepipeUps, 1, -1 do
      local thispipeUps = tablepipeUps[i]
      -- Remove pipeUpss
      display.remove( thispipeUps )
      table.remove( thispipeUps, i )
    end
    for i = #tablepipeDowns, 1, -1 do
      local thispipeDowns = tablepipeDowns[i]
      -- Remove pipeUpss
      display.remove( thispipeDowns )
      table.remove( thispipeDowns, i )
    end
      display.remove( bird )
      bird:removeSelf()
      bird = nil
end

-- Function gameOver
local function gameOver()

  scoreText.alpha = 0
  titleGameOver.alpha = 1
  pannel.alpha = 1
  btnPlayAgain.alpha = 1
  pannelScoreText.alpha = 1
  pannelScoreText.text = Score
  pannelBestScoreText.alpha = 1
  pannelBestScoreText.text = bestScore
  timer.pause( createLoopTimer )

  if ( Score < 10 ) then
    medalSilver.alpha = 1
  elseif ( Score > 10 ) then
    medalGold.alpha = 1
  end
  saveBestScore()
  loadBestScore()
  clearAll()
end

-- THE NEXT FUNCTION GAMELOOP FOR CREATE PIPE
local function gameLoop()

  if( gameStatus == 1 ) then
    background.alpha = 1
    land.alpha = 1
    scoreText.text = Score -- Setup scoreText with current value of Score
    scoreText.alpha = 1
    vBird = vBird + delta * g
    yBird = yBird + delta * vBird

    bird.x = xBird
    bird.y = yBird
    bird.rotation =  -30*math.atan(vBird/uBird)

  elseif( gameStatus == 2 ) then
    -- Set display intro tab for start game
    gameOver()
    timer.pause( gameLoopTimer )

  elseif( gameStatus == 0 ) then

    scoreText.alpha = 0
    gameReady.alpha = 1
    background.alpha = 1
    land.alpha = 1
    titleGameOver.alpha = 0
    pannel.alpha = 0
    pannelScoreText.alpha = 0
    medalGold.alpha = 0
    medalSilver.alpha = 0
    btnPlayAgain.alpha = 0

  end

  -- Clear obj
    for i = #tableHoles, 1, -1 do
        local thisHole = tableHoles[i]
        if ( thisHole.x == 0 ) then
          -- Remove holes
            display.remove( thisHole )
            table.remove( thisHole, i )
        end
    end
    for i = #tablepipeUps, 1, -1 do
      local thispipeUps = tablepipeUps[i]
      if( thispipeUps.x == 0 ) then
      -- Remove pipeUpss
        display.remove( thispipeUps )
        table.remove( thispipeUps, i )
      end
    end
    for i = #tablepipeDowns, 1, -1 do
      local thispipeDowns = tablepipeDowns[i]
      if( thispipeDowns.x == 0 ) then
      -- Remove pipeUpss
        display.remove( thispipeDowns )
        table.remove( thispipeDowns, i )
      end
    end

end
local function Reset()
  gameStatus = 0
  Score = 0
  pannelBestScoreText.alpha = 0
  timer.resume( gameLoopTimer )
end

-- Start

setUpDisplayBackGround()
setUpDisplayLand()
setUpDisplayGameReady()
setUpDisplayScoreText()
setUpDisplayPannel()
setUpDisplayTitleGameOver()
setUpDisplayMedalGold()
setUpDisplayMedalSilver()
setUpDisplayBtnPlayAgain()
setUpDisplayPannelScoreText()
setUpDisplayPannelBestScoreText()

gameReady:addEventListener( "tap", tabToPlay )
background:addEventListener( "tap", tabToFly )
btnPlayAgain:addEventListener( "tap", Reset )
-- background:addEventListener( "touch", onBackGroundTouch )

gameLoopTimer = timer.performWithDelay( 25, gameLoop, 0 )

Runtime:addEventListener( "collision", onCollision )

--------------
--
-- local function landScroller( self, event )
--   if ( self.x < (- self.width + ( self.speed * 2 ) ) ) then
--     self.x =  self.width
--   else
--     self.x = self.x - self.speed
--   end
-- end
