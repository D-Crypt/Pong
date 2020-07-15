WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Virtual resolution to emulate retro visuals (i.e. similar resolution to the NES)
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

push = require "push"

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    smallFont = love.graphics.newFont("Fonts/PressStart2P.ttf", 8)
    scoreFont = love.graphics.newFont("Fonts/PressStart2P.ttf", 16)

    player1Score = 0
    player2Score = 0

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = false
    }) 
end

function love.draw()
    push:apply("start") -- Render at virtual resolution

    -- Change canvas colour with RGB manipulation
    -- Each value (Red, Green, Blue, Alpha) is divided by 255 as LOVE uses a scale of 0-1.
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

    love.graphics.setFont(smallFont)
    love.graphics.printf(
        "Hello Pong!", -- String to print
        0,             -- Position on x-axis 
        20,            -- Position on y-axis
        VIRTUAL_WIDTH, -- Wrap the line after this many horizontal pixels
        "center")      -- Alignment

    love.graphics.setFont(scoreFont)
    love.graphics.print(player1Score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 5)
    love.graphics.print(player2Score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 5)

    love.graphics.rectangle("fill", VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4) -- Ball
    love.graphics.rectangle("fill", 5, 40, 5, 20) -- Left paddle
    love.graphics.rectangle("fill", VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 60, 5, 20) -- Right paddle

    push:apply("end")
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end