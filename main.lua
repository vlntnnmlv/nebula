
package.path = package.path..";./src/?.lua"

require("core/scene")
require("core/args")
require("core/logger")
require("core/keys")

SCREEN_WIDTH, SCREEN_HEIGHT = nil, nil

local function exit()
    Logger.dispose()
    love.event.quit()
end

local function init(args)
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setBlendMode("alpha", "alphamultiply")
    love.graphics.setBackgroundColor(1.0, 1.0, 1.0, 1.0)

    love.graphics.setFont(love.graphics.newFont("resources/fonts/alagard.ttf", 32))

    love.mouse.setCursor(love.mouse.newCursor(love.image.newImageData("resources/textures/cursor.png"), 0, 0))

    local argsResults = HandleArgs(args)
    SCREEN_WIDTH, SCREEN_HEIGHT = love.graphics.getDimensions()

    Scene.loadScenes("src/game/scenes")

    Scene.switchScene(argsResults.scene)
end

function love.load(args)
    init(args)
end

function love.draw()
    Scene.current.drawAll()
end

function love.keyreleased(key)
    Keys.released(key)

    if key == "escape" then
        exit()
    elseif key == "p" then
        love.graphics.captureScreenshot(os.date("%m-%d-%Y_%H%-M-%S", os.time())..".png")
    end
end

function love.keypressed(key)
    Keys.pressed(key)
end

function love.update(dt)
    Scene.current.updateAll(dt)
end

function love.mousepressed(_, _, _)
    Scene.current.updateMouseButtonEvent(true)
end

function love.mousereleased(_, _, _)
    Scene.current.updateMouseButtonEvent(false)
end

-- RootCanvas = nil;
-- RootShader = nil;

-- PixelCanvas = nil;
-- PixelShader = nil;

-- function love.load()
--     RootCanvas = love.graphics.newCanvas(400, 400)

--     RootShader = love.graphics.newShader("resources/shaders/shine.glsl");
--     RootShader:send("iColor", { 1.0, 0.0, 0.0, 1.0})

--     PixelCanvas = love.graphics.newCanvas(400, 400)

--     PixelShader = love.graphics.newShader("resources/shaders/pixelize.glsl");
--     PixelShader:send("iScale", { 32, 32})
-- end

-- function love.draw()
--     love.graphics.setShader(RootShader)
--     RootShader:send("iTime", love.timer.getTime())
--     love.graphics.setCanvas(PixelCanvas)
--     love.graphics.clear()

--     love.graphics.draw(RootCanvas, 0, 0)

--     love.graphics.setCanvas()
--     love.graphics.setShader(PixelShader)
--     love.graphics.draw(PixelCanvas, 0, 0)
-- end