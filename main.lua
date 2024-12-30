dofile("src/core/scene.lua")
dofile("src/core/gif.lua")
dofile("src/game/planet.lua")
dofile("src/game/fps.lua")
dofile("src/game/cosmos.lua")

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setFont(love.graphics.newFont("resources/fonts/alagard.ttf", 32))
    love.mouse.setCursor(love.mouse.newCursor(love.image.newImageData("resources/textures/cursor.png"), 0, 0))

    local w, h = 1080, 720

    -- MENU
    local sceneMenu = Scene.new("Menu")
    sceneMenu.drawGizmos = true

    local root = Node.new(sceneMenu, nil, 0, 0, w, h, Palette.darkest, true)
    local overlay = Node.new(sceneMenu, root, 0, 0, w, h, Color(0, 0, 0, 0), true)
    FPS.new(sceneMenu, overlay, 20, 15, 32, Palette.gizmoRed)

    local frames = List.new()
    frames.append("resources/textures/flame1.png")
    frames.append("resources/textures/flame2.png")

    GIF.new(sceneMenu, overlay, 40, 40, 64, 64, frames, Color(1, 1, 1, 1), true)

    local menuW, menuH = 500, 400
    local menu = Node.new(sceneMenu, root, w / 2 - menuW / 2, h / 2 - menuH / 2, menuW, menuH, Color(0,0,0,0), false)

    local play = Node.text(sceneMenu, menu, "Play", w / 2, h / 2 - 32, 64, Palette.bright, false, true)
    local function playAction(pressed)
        if pressed then return end
        Scene.switchScene("Gameplay")
    end
    play.setAction(playAction)

    Node.text(sceneMenu, menu, "Settings", w / 2, h / 2 + 32, 64, Palette.brightest, false, true)

    ---- GAMEPLAY
    local sceneGameplay = Scene.new("Gameplay")
    sceneGameplay.drawGizmos = true

    local root = Node.new(sceneGameplay, nil, 0, 0, w, h, Color(0.117, 0.109, 0.223, 1.0), true)
    local overlay = Node.new(sceneGameplay, root, 0, 0, w, h, Color(0.0, 0.0, 0.0, 0.0), true)
    FPS.new(sceneGameplay, overlay, 20, 15, 32, Palette.gizmoRed)
    Cosmos.new(sceneGameplay, root, w, h)

    -- CurrentScene
    Scene.switchScene("Menu")

    canvas = love.graphics.newCanvas(w,h)
end

function love.draw()
    love.graphics.setCanvas(canvas)
    Scene.current.drawAll()
    love.graphics.setCanvas()

    love.graphics.setShader(love.graphics.newShader("resources/shaders/pixelize.glsl"))
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