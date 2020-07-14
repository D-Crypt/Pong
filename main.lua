WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Virtual resolution to emulate retro visuals (i.e. similar resolution to the NES)
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

push = require "push"

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    smallFont = love.graphics.newFont("Fonts/PressStart2P.ttf", 8)
    love.graphics.setFont(smallFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = false
    }) 
end

function love.draw()
    push:apply("start")

    love.graphics.printf(
        "Hello Pong!",            -- String to print
        0,                        -- Position on x-axis 
        (VIRTUAL_HEIGHT / 2) - 6, -- Position on y-axis
        VIRTUAL_WIDTH,            -- Wrap the line after this many horizontal pixels
        "center")                 -- Alignment

    push:apply("end")
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end