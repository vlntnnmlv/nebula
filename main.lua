dofile("src/core/scene.lua")
dofile("src/game/planet.lua")

SceneMenu = nil
SceneGameplay = nil
CurrentScene = nil

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setFont(love.graphics.newFont("resources/fonts/alagard.ttf", 32))
    love.mouse.setCursor(love.mouse.newCursor(love.image.newImageData("resources/textures/cursor.png"), 0, 0))

    local w, h = 1080, 720

    -- MENU
    SceneMenu = Scene.new()
    SceneMenu.drawGizmos = true

    local root = Node.new(SceneMenu, nil, 0, 0, w, h, palette.darkest, true)
    local overlay = Node.new(SceneMenu, root, 0, 0, w, h, Color(0.0, 0.0, 0.0, 0.0), true)
    -- fps = Node.text(SceneMenu, overlay, 60, 20, 15, 32, palette.gizmoRed, true, false)

    local menuW, menuH = 500, 400
    local menu = Node.new(SceneMenu, root, w / 2 - menuW / 2, h / 2 - menuH / 2, menuW, menuH, Color(0,0,0,0), false)

    local play = Node.text(SceneMenu, menu, "Play", w / 2, h / 2 - 32, 64, palette.bright, false, true)
    local function playAction()
        CurrentScene = SceneGameplay
        print("swap scene")
    end
    play.setAction(playAction)

    local settings = Node.text(SceneMenu, menu, "Settings", w / 2, h / 2 + 32, 64, palette.brightest, false, true)

    ---- GAMEPLAY
    SceneGameplay = Scene.new()
    SceneGameplay.drawGizmos = true

    local root = Node.new(SceneGameplay, nil, 0, 0, w, h, palette.darkest, true)
    local overlay = Node.new(SceneGameplay, root, 0, 0, w, h, Color(0.0, 0.0, 0.0, 0.0), true)
    -- fps = Node.text(SceneGameplay, overlay, 60, 20, 15, 32, palette.gizmoRed, true, false)
    mainPlanet = Planet.new(SceneGameplay, root, w / 2, h / 2, 128)

    planets = {}

    for i = 1,20 do 
        local x = love.math.random() * w
        local y = love.math.random() * h
        local m = love.math.random() * 28 + 4
        planets[i] = Planet.new(SceneGameplay, root, x, y, m)
    end

    -- CurrentScene
    CurrentScene = SceneMenu
end

function love.draw()
    CurrentScene.drawAll()
end

function love.update(dt)
    -- fps.setText(love.timer.getFPS())

    -- local function dist2(x1, y1, x2, y2)
    --     return x1 * y1 + x2 * y2
    -- end

    -- for i = 1,20 do
    --     local p1 = planets[i]
    --     local ax, ay = 0, 0
    --     for j = i,20 do
    --         local p2 = planets[j]
    --         local dist = dist2(p1.x, p1.y, p2.x, p2.y)
    --         if dist > p1.m + p2.m then 
    --             local f = p1.m * p2.m / dist

    --             local dx, dy = p2.x - p1.x, p2.y - p1.y
    --             local a = math.atan2(dy, dx)

    --             ax = ax + f * math.cos(a)
    --             ay = ay + f * math.sin(a)
    --         end
    --     end

    --     local p2 = mainPlanet
    --     local dist = dist2(p1.x, p1.y, p2.x, p2.y)
    --     if dist > p1.m + p2.m then
    --         local f = p1.m * p2.m / dist

    --         local dx, dy = p2.x - p1.x, p2.y - p1.y
    --         local a = math.atan2(dy, dx)

    --         ax = ax + f * math.cos(a)
    --         ay = ay + f * math.sin(a)
    --     end

    --     p1.ax = ax
    --     p1.ay = ay
    -- end

    -- for i = 1,20 do 
    --     planets[i].updatePhysics(dt)
    -- end

    CurrentScene.updateAll(dt)
end

function love.mousepressed(_, _, _)
    CurrentScene.updateMouseButtonEvent(true)
end

function love.mousereleased(_, _, _)
    CurrentScene.updateMouseButtonEvent(false)
end