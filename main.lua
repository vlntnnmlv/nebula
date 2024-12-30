dofile("src/core/scene.lua")
dofile("src/game/planet.lua")
dofile("src/game/fps.lua")
dofile("src/game/cosmos.lua")

SceneMenu = nil
SceneGameplay = nil
CurrentScene = nil

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setFont(love.graphics.newFont("resources/fonts/alagard.ttf", 32))
    love.mouse.setCursor(love.mouse.newCursor(love.image.newImageData("resources/textures/cursor.png"), 0, 0))

    local w, h = 1080, 720

    -- MENU
    SceneMenu = Scene.new("Menu")
    -- SceneMenu.drawGizmos = true

    local root = Node.new(SceneMenu, nil, 0, 0, w, h, palette.darkest, true)
    local overlay = Node.new(SceneMenu, root, 0, 0, w, h, Color(0.0, 0.0, 0.0, 0.0), true)
    FPS.new(SceneMenu, overlay, 20, 15, 32, palette.gizmoRed)

    local menuW, menuH = 500, 400
    local menu = Node.new(SceneMenu, root, w / 2 - menuW / 2, h / 2 - menuH / 2, menuW, menuH, Color(0,0,0,0), false)

    local play = Node.text(SceneMenu, menu, "Play", w / 2, h / 2 - 32, 64, palette.bright, false, true)
    local function playAction(pressed)
        if pressed then return end
        CurrentScene = SceneGameplay
    end
    play.setAction(playAction)

    local settings = Node.text(SceneMenu, menu, "Settings", w / 2, h / 2 + 32, 64, palette.brightest, false, true)

    ---- GAMEPLAY
    SceneGameplay = Scene.new("Gameplay")
    SceneGameplay.drawGizmos = true

    local root = Node.new(SceneGameplay, nil, 0, 0, w, h, Color(0.117, 0.109, 0.223, 1.0), true)
    local overlay = Node.new(SceneGameplay, root, 0, 0, w, h, Color(0.0, 0.0, 0.0, 0.0), true)
    FPS.new(SceneGameplay, overlay, 20, 15, 32, palette.gizmoRed)
    local cosmos = Cosmos.new(SceneGameplay, root, w, h)
    
    CurrentPlanet = nil
    cosmos.setAction(
        function(pressed)
            local mouseX, mouseY = love.mouse.getPosition()
            if pressed then
                CurrentPlanet = Planet.new(SceneGameplay, cosmos, mouseX, mouseY, 20)
            else
                if CurrentPlanet == nil then return end
                CurrentPlanet.vx = CurrentPlanet.cx - mouseX
                CurrentPlanet.vy = CurrentPlanet.cy - mouseY
                cosmos.addPlanet(CurrentPlanet)
            end
        end
    )

    -- CurrentScene
    CurrentScene = SceneMenu

    canvas = love.graphics.newCanvas(w,h)
end

function love.draw()
    love.graphics.setCanvas(canvas)
    CurrentScene.drawAll()
    love.graphics.setCanvas()

    love.graphics.setShader(love.graphics.newShader("resources/shaders/pixelize.glsl"))
    love.graphics.draw(canvas, 0, 0)
end

function love.update(dt)
    CurrentScene.updateAll(dt)
end

function love.mousepressed(_, _, _)
    CurrentScene.updateMouseButtonEvent(true)
end

function love.mousereleased(_, _, _)
    CurrentScene.updateMouseButtonEvent(false)
end