local position_x = 0
local position_y = 0
local positions = {}
local cookies = {}
local direction = "right"
local playing = true
local snake_length = 10
local score = 0
local sleep_timeout = 0.1
local blip = love.audio.newSource("blip.wav", "static")

blip:setVolume(0.1)

love.graphics.setPointSize(10)

function love.draw()
  -- print the current score on screen
  love.graphics.print("Score: " .. score, 10, 10)

  -- prints the snake tail
  for i, position in ipairs(positions) do
    love.graphics.points(position[1], position[2])
  end

  -- prints the cookies
  for i, cookie in ipairs(cookies) do
    love.graphics.points(cookie[1], cookie[2])
  end
  
  -- if the number of cookies on screen is less than 5, create a new one
  if #cookies < 100 then
    create_random_cookie()
  end

  -- keep the number of positions in the table to 100
  if #positions > snake_length then
    table.remove(positions, 1)
  end

  -- function called to see if up/down/left/right are pressed
  update_current_position()


  -- if the current position is in the table then stop the game
  for i, position in ipairs(positions) do
    if position[1] == position_x and position[2] == position_y then
      playing = false
    end
  end
  
  -- if the snake is out of the screen, stop the game
  if position_x < 0 or position_x > 800 or position_y < 0 or position_y > 600 then
    playing = false
  end
  
  -- if the snake is on a cookie, increase the score and the snake length
  for i, cookie in ipairs(cookies) do
    if cookie[1] == position_x and cookie[2] == position_y then
      score = score + 1
      snake_length = snake_length + 10
      sleep_timeout = sleep_timeout - 0.002
  
      blip:play()
      table.remove(cookies, i)
    end
  end

  -- print on the screen that the game is over
  if playing == false then
    love.graphics.print("Game Over", 400, 300)
  end

  -- if the current position is not in the positions table, add it
  if playing == true then
    table.insert(positions, {position_x, position_y})
    love.graphics.points(position_x, position_y)
  end

  love.timer.sleep(sleep_timeout)
end

function create_random_cookie()
  local width, height = love.graphics.getDimensions()
  local cookie_x = math.random(0, width / 10)
  local cookie_y = math.random(0, height / 10)
  table.insert(cookies, {cookie_x * 10, cookie_y * 10})
end

function update_current_position()
  if direction == "up" then
    position_y = position_y - 10
  end
  
  if direction == "down" then
    position_y = position_y + 10
  end
  
  if direction == "left" then
    position_x = position_x - 10
  end

  if direction == "right" then
    position_x = position_x + 10
  end
end

function love.keypressed(key)
  if key == "up" and direction ~= "down" then
    direction = "up"
  end
  
  if key == "down" and direction ~= "up" then
    direction = "down"
  end
  
  if key == "left" and direction ~= "right" then
    direction = "left"
  end
  
  if key == "right" and direction ~= "left" then
    direction = "right"
  end
end

function love.mousepressed(x, y, button, istouch)
  if button == 1 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
    position_x = 0
    position_y = 0
    positions = {}
    cookies = {}
    direction = "right"
    playing = true
    snake_length = 10
    score = 0
    sleep_timeout = 0.1
  end
end
