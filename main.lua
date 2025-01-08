dofile("src/core/scene.lua")
dofile("src/core/args.lua")
dofile("src/core/logger.lua")

SCREEN_WIDTH, SCREEN_HEIGHT = nil, nil

local function exit()
    Logger.dispose()
    love.event.quit()
end

function love.load(args)
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setBlendMode("alpha", "alphamultiply")
    love.graphics.setBackgroundColor(1,1,1,1)

    love.graphics.setFont(love.graphics.newFont("resources/fonts/alagard.ttf", 32))
    love.mouse.setCursor(love.mouse.newCursor(love.image.newImageData("resources/textures/cursor.png"), 0, 0))

    local argsResults = HandleArgs(args)
    SCREEN_WIDTH, SCREEN_HEIGHT = love.graphics.getDimensions()

    Scene.loadScenes("src/game/scenes")

    Scene.switchScene(argsResults.scene)
end

function love.draw()
    Scene.current.drawAll()
end

local held = { }
local cameraMoveSpeed = 50
local cameraZoomSpeed = 0.5

function love.keyreleased(key)
    held[key] = false
    if key == "escape" then
        exit()
    elseif key == "p" then
        love.graphics.captureScreenshot(os.date("%m-%d-%Y_%H%-M-%S", os.time())..".png")
    end
end

function love.keypressed(key)
    held[key] = true
end

function love.update(dt)
    Scene.current.updateAll(dt)

    if held["="] then
        Scene.current.scale = Scene.current.scale + dt * cameraZoomSpeed
    end

    if held["-"] then
        Scene.current.scale = Scene.current.scale - dt * cameraZoomSpeed
    end

    if held["up"] then
        Scene.current.offsetY = Scene.current.offsetY + dt * cameraMoveSpeed
    end

    if held["down"] then
        Scene.current.offsetY = Scene.current.offsetY - dt * cameraMoveSpeed
    end

    if held["right"] then
        Scene.current.offsetX = Scene.current.offsetX - dt * cameraMoveSpeed
    end

    if held["left"] then
        Scene.current.offsetX = Scene.current.offsetX + dt * cameraMoveSpeed
    end
end

function love.mousepressed(_, _, _)
    Scene.current.updateMouseButtonEvent(true)
end

function love.mousereleased(_, _, _)
    Scene.current.updateMouseButtonEvent(false)
end