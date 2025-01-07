dofile("src/core/scene.lua")
dofile("src/core/args.lua")
dofile("src/core/logger.lua")

SCREEN_WIDTH, SCREEN_HEIGHT = love.graphics.getDimensions()

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

    Scene.loadScenes("src/game/scenes")

    Scene.switchScene(argsResults.scene)
end

function love.draw()
    Scene.current.drawAll()
end

function love.keyreleased(key)
    if key == "escape" then
        exit()
    elseif key == "p" then
        love.graphics.captureScreenshot("screenshot"..os.time()..".png")
    elseif key == "-" then
        Scene.current.nodes[0].setScale(
            Scene.current.nodes[0].sx - 0.01,
            Scene.current.nodes[0].sy - 0.01
        )
    elseif key == "=" then
        Scene.current.nodes[0].setScale(
            Scene.current.nodes[0].sx + 0.01,
            Scene.current.nodes[0].sy + 0.01
        )
    end
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