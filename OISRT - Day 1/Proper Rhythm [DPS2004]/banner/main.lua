function love.load()
  love.graphics.setDefaultFilter( "nearest", "nearest")
  love.filesystem.setIdentity("properrhythmbanner")
  love.window.setMode(418, 164, {resizable=false})
  grid = love.graphics.newImage('grid.png')
  text = love.graphics.newImage('text.png')
  wave = love.graphics.newImage('wave.png')
  i=-1
end

function love.update()
  if i < 418 then
    i = i + 1
  end
  
end

function love.draw()
  love.graphics.draw(wave,(0-i)%418)
  love.graphics.draw(wave,(0-i)%418-418)
  love.graphics.draw(grid)
  love.graphics.draw(text,0,math.sin(i*(math.pi/209))*10)
  if i < 418 then
    love.graphics.captureScreenshot(i .. ".png")
  end
end