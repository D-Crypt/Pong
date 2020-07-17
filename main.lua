Class = require "class"
push = require "push"

require "Ball"
require "Paddle"

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Virtual resolution to emulate retro visuals
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest") -- Removes blur from default filter
    love.window.setTitle("Pong")

    smallFont = love.graphics.newFont("Fonts/PressStart2P.ttf", 8)
    scoreFont = love.graphics.newFont("Fonts/PressStart2P.ttf", 16)

    player1Score = 0
    player2Score = 0

    servingPlayer = math.random(2) == 1 and 1 or 2
    winningPlayer = 0

    hitCounter = 0
    hiScore = 0

    resetGame()
    gameState = "start"

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = false
    }) 
end

function love.update(dt)
    if ball:collides(paddle1) or ball:collides(paddle2) then  
        -- Speed up ball based on how many times it has been hit      
        if ball.dx < 0 then
            ball.dx = ball.dx - hitCounter
        else
            ball.dx = ball.dx + hitCounter
        end

        -- deflect ball to the opposite direction
        ball.dx = -ball.dx

        hitCounter = hitCounter + 1
    end

    if ball.y <= 0 then
        -- Deflect ball down and reset its position if it moves out of bounds
        ball.y = 0
        ball.dy = -ball.dy
    end

    if ball.y >= VIRTUAL_HEIGHT - 4 then
        -- Deflect ball up and reset its position if it moves out of bounds
        ball.y = VIRTUAL_HEIGHT - 4
        ball.dy = -ball.dy
    end

    -- Update scores
    if ball.x >= VIRTUAL_WIDTH - 4 then
        player1Score = player1Score + 1

        if player1Score == 3 then
            resetGame()
            gameState = "victory"
            winningPlayer = 1
        else
            resetGame()
            servingPlayer = 2
            ball.dx = -100 -- Serve to player 2
        end

    elseif ball.x <= 0 then
        player2Score = player2Score + 1

        if player2Score == 3 then
            resetGame()
            gameState = "victory"
            winningPlayer = 2
        else
            resetGame()
            servingPlayer = 1
            ball.dx = 100 -- Serve to player 1
        end
    end

    paddle1:update(dt)
    paddle2:update(dt)

    -- Player 1 controls
    if love.keyboard.isDown("w") then
        paddle1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown("s") then
        paddle1.dy = PADDLE_SPEED
    else
        paddle1.dy = 0
    end

    -- Player 2 controls
    if love.keyboard.isDown("up") then
        paddle2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown("down") then
        paddle2.dy = PADDLE_SPEED
    else
        paddle2.dy = 0
    end

    if gameState == "play" then
        ball:update(dt)
    end

end

function love.draw()
    push:apply("start") -- Render at virtual resolution

    -- Change canvas colour with RGBA manipulation
    -- Each value (Red, Green, Blue, Alpha) is divided by 255 as LOVE uses a scale of 0-1.
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

    love.graphics.setFont(smallFont)

    if gameState == "start" then
        love.graphics.printf("PRESS SPACE TO START!", 0, 20, VIRTUAL_WIDTH, "center") 
    elseif gameState == "serve" then
        love.graphics.printf("PLAYER " .. tostring (servingPlayer) .. " TO SERVE!", 0, 20, VIRTUAL_WIDTH, "center")
    elseif gameState == "victory" then
        -- Victory message
        love.graphics.setFont(scoreFont)
        love.graphics.printf("PLAYER " .. tostring (winningPlayer) .. " WINS!", 0, 20, VIRTUAL_WIDTH, "center")
        love.graphics.setFont(smallFont)
    else
        love.graphics.printf("HITS = " .. tostring (hitCounter), 0, 20, VIRTUAL_WIDTH, "center")
    end

    love.graphics.setFont(scoreFont)
    love.graphics.print(player1Score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 5)
    love.graphics.print(player2Score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 5)

    ball:render()
    paddle1:render()
    paddle2:render()

    displayFPS()
    displayHiScore()

    push:apply("end")
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "space" then
        if gameState == "start" then
            gameState = "serve"
        elseif gameState == "serve" then
            gameState = "play"
        elseif gameState == "victory" then
            player1Score = 0
            player2Score = 0
            gameState = "start"
        end
    end
end

function resetGame()
    gameState = "serve"
    paddle1 = Paddle(5, VIRTUAL_HEIGHT / 2 - 10, 5, 20)
    paddle2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT / 2 - 10, 5, 20)
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    if servingPlayer == 1 then
        ball.dx = 100
    else
        ball.dx = -100
    end

    if hiScore < hitCounter then
        hiScore = hitCounter
    end

    hitCounter = 0
end

function displayFPS()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.setFont(smallFont)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 15, 0)
    love.graphics.setColor(1, 1, 1, 1) -- Set colour back to white for other objects being drawn
end

function displayHiScore()
    love.graphics.setColor(0, 0, 1, 1)
    love.graphics.setFont(smallFont)
    love.graphics.print("HI-SCORE:" .. tostring (hiScore), VIRTUAL_WIDTH - 100, 0)
    love.graphics.setColor(1, 1, 1, 1)
end