
NUMBER_OF_COOKIES = 50
SLEEP_TIMEOUT = 0.03
MAX_SNAKE_LENGTH = 10
SNAKE_LENGTH = 0
STATUS = 'START'
BLIP = love.audio.newSource("blip.wav", "static")
GAME_OVER_SOUND = love.audio.newSource("the-price-is-right-losing-horn.mp3", "static")
BLIP:setVolume(0.1)
love.graphics.setPointSize(10)
love.window.setFullscreen(true)
POSITION_X = 0
POSITION_Y = 0
POSITIONS = {}
COOKIES = {}
DIRECTION = "right"
SCORE = 0
score_font = love.graphics.newFont("font.ttf", 12)
game_over_font = love.graphics.newFont("font.ttf", 40)

function love.keypressed(key)
  if key == "up" and DIRECTION ~= "down" then
    DIRECTION = "up"
  end
  
  if key == "down" and DIRECTION ~= "up" then
    DIRECTION = "down"
  end
  
  if key == "left" and DIRECTION ~= "right" then
    DIRECTION = "left"
  end
  
  if key == "right" and DIRECTION ~= "left" then
    DIRECTION = "right"
  end
end

function love.mousepressed(x, y, button, istouch)
  if button == 1 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
    local width, height = love.graphics.getDimensions()
    local directions = {"left", "right", "up", "down"}
    POSITION_X = math.floor(math.random() * width)
    POSITION_Y = math.floor(math.random() * height)
    MAX_SNAKE_LENGTH = 50
    SNAKE_LENGTH = 0
    POSITIONS = {}
    COOKIES = {}
    DIRECTION = directions[math.random(1, 4)]
    SCORE = 0  
    STATUS = 'PLAYING'  
  end
end

function love.draw()
  local width, height = love.graphics.getDimensions()

  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(score_font)
  love.graphics.print("Score: " .. SCORE, 10, 10)
  
  if STATUS == "PLAYING" then
    if DIRECTION == "up" then
      POSITION_Y = POSITION_Y - 5
    end
    
    if DIRECTION == "down" then
      POSITION_Y = POSITION_Y + 5
    end
    
    if DIRECTION == "left" then
      POSITION_X = POSITION_X - 5
    end
  
    if DIRECTION == "right" then
      POSITION_X = POSITION_X + 5
    end
  
    if POSITION_X < 0 or POSITION_X > width or POSITION_Y < 0 or POSITION_Y > height then
      STATUS = 'GAME_OVER'
    end

    for i, cookie in ipairs(COOKIES) do
      if  (cookie[2] + 10  >  POSITION_Y )  and ( cookie[2]  < POSITION_Y + 10 ) and (cookie[1] + 10  >  POSITION_X )  and ( cookie[1]  < POSITION_X + 10 )  then
        SCORE = SCORE + 1
        MAX_SNAKE_LENGTH = MAX_SNAKE_LENGTH + 10
        SLEEP_TIMEOUT = SLEEP_TIMEOUT - 0.0001
    		-- psystem:emit(32)

        BLIP:play()
        table.remove(COOKIES, i)
      end
    end

    for i, position in ipairs(POSITIONS) do
      if position.x == POSITION_X and position.y == POSITION_Y then
        STATUS = 'GAME_OVER'
      end
    end

    if #COOKIES < NUMBER_OF_COOKIES then
      local cookie_x = math.random(0, width)
      local cookie_y = math.random(0, height)
      table.insert(COOKIES, {cookie_x, cookie_y})
    end

    
    local new_position = {}
    new_position.x = POSITION_X
    new_position.y = POSITION_Y

    if #POSITIONS < MAX_SNAKE_LENGTH then
      POSITIONS[SNAKE_LENGTH] = new_position
      table.insert(POSITIONS, new_position)
    else
      table.remove(POSITIONS, 1)
      table.insert(POSITIONS, new_position)
    end

    -- print_cookies
    for i, cookie in ipairs(COOKIES) do
      love.graphics.setColor(1, 1, 1)
      love.graphics.ellipse("fill", cookie[1], cookie[2], 5, 5)
    end
  end

  if STATUS == 'GAME_OVER' then
    STATUS = 'ENDED'
    GAME_OVER_SOUND:play()
  end

  if STATUS == 'ENDED' then
    love.graphics.setFont(game_over_font)
    love.graphics.printf("GAME OVER!!!", 0, height / 2, width, 'center')
    love.graphics.printf("FINAL SCORE " .. SCORE, 0, height / 2 + 50, width, 'center')
  end

  -- print snake tail
  x = 0
  for i, position in ipairs(POSITIONS) do
    if x % 4 == 0 then
      r, g, b, a = love.math.colorFromBytes(0, 204, 0)
    else
      r, g, b, a = love.math.colorFromBytes(0, 102, 0)
    end
    x = x + 1

    love.graphics.setColor(r, g, b, a)
    love.graphics.ellipse("fill", position.x, position.y, 5, 5)
  end
  
  love.timer.sleep(SLEEP_TIMEOUT)
end
