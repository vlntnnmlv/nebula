dofile("src/core/scene.lua")
dofile("src/core/gif.lua")
dofile("src/game/planet.lua")
dofile("src/game/fps.lua")
dofile("src/game/cosmos.lua")

SCREEN_WIDTH, SCREEN_HEIGHT = 1080, 720

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setFont(love.graphics.newFont("resources/fonts/alagard.ttf", 32))
    love.mouse.setCursor(love.mouse.newCursor(love.image.newImageData("resources/textures/cursor.png"), 0, 0))


    -- MENU
    dofile("src/game/scenes/sceneMenu.lua")

    -- GAMEPLAY
    dofile("src/game/scenes/sceneGameplay.lua")

    -- CurrentScene
    Scene.switchScene("Menu")

    canvas = love.graphics.newCanvas(SCREEN_WIDTH,SCREEN_HEIGHT)
end

function love.draw()
    love.graphics.setCanvas(canvas)
    Scene.current.drawAll()
    love.graphics.setCanvas()

    -- love.graphics.setShader(love.graphics.newShader("resources/shaders/pixelize.glsl"))
    love.graphics.draw(canvas, 0, 0)
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