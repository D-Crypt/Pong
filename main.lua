WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Virtual resolution to emulate retro visuals
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

push = require "push"

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    smallFont = love.graphics.newFont("Fonts/PressStart2P.ttf", 8)
    scoreFont = love.graphics.newFont("Fonts/PressStart2P.ttf", 16)

    resetGame()
    
    gameState = "start"

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = false
    }) 
end

function love.update(dt)
    -- Player 1 controls
    if love.keyboard.isDown("w") then
        -- The max and min functions prevenetGame from moving beyond the canvas boundaries
        player1Y = math.max(0, player1Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown("s") then
        player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt)
    end

    -- Player 2 controls
    if love.keyboard.isDown("up") then
        player2Y = math.max(0, player2Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown("down") then
        player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * dt)
    end

    if gameState == "play" then
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt
    end

end

function love.draw()
    push:apply("start") -- Render at virtual resolution

    -- Change canvas colour with RGB manipulation
    -- Each value (Red, Green, Blue, Alpha) is divided by 255 as LOVE uses a scale of 0-1.
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

    love.graphics.setFont(smallFont)

    if gameState == "start" then
        love.graphics.printf("State = Start!", 0, 20, VIRTUAL_WIDTH, "center") 
    else
        love.graphics.printf("State = Play!", 0, 20, VIRTUAL_WIDTH, "center")
    end

    love.graphics.setFont(scoreFont)
    love.graphics.print(player1Score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 5)
    love.graphics.print(player2Score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 5)

    love.graphics.rectangle("fill", ballX, ballY, 4, 4) -- Ball
    love.graphics.rectangle("fill", player1X, player1Y, 5, 20) -- Left paddle
    love.graphics.rectangle("fill", player2X, player2Y, 5, 20) -- Right paddle

    push:apply("end")
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "space" then
        if gameState == "start" then
            gameState = "play"
        else
            gameState = "start"
            resetGame()
        end
    end
end

function resetGame()
    player1Score = 0
    player2Score = 0

    player1Y = 40
    player2Y = VIRTUAL_HEIGHT - 60

    player1X = 5
    player2X = VIRTUAL_WIDTH - 10

    ballX = VIRTUAL_WIDTH / 2 - 2
    ballY = VIRTUAL_HEIGHT / 2 - 2

    -- "DX" means delta of x, i.e. the velocity of the ball across the two axes
    ballDX = math.random(2) == 1 and -100 or 100
    ballDY = math.random(-50, 50)
end