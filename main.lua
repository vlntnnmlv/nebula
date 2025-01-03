dofile("src/core/scene.lua")

SCREEN_WIDTH, SCREEN_HEIGHT = 1080, 720

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setFont(love.graphics.newFont("resources/fonts/alagard.ttf", 32))
    love.mouse.setCursor(love.mouse.newCursor(love.image.newImageData("resources/textures/cursor.png"), 0, 0))

    -- SCENES
    Scene.drawGizmos = true
    dofile("src/game/scenes/sceneMenu.lua")
    dofile("src/game/scenes/sceneGameplay.lua")

    Scene.switchScene("Menu")

    -- TEMP: TODO: Move canvas+shader logic to Node
    Canvas = love.graphics.newCanvas(SCREEN_WIDTH,SCREEN_HEIGHT)
end

function love.draw()
    love.graphics.setCanvas(Canvas)
    Scene.current.drawAll()
    love.graphics.setCanvas()

    -- love.graphics.setShader(love.graphics.newShader("resources/shaders/pixelize.glsl"))
    love.graphics.draw(Canvas, 0, 0)
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