dofile("src/core/node.lua")
dofile("src/game/planet.lua")

function love.load()
    Node.drawGizmos = true
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setFont(love.graphics.newFont("resources/fonts/alagard.ttf", 32))

    local w, h = 1080, 720

    local root = Node.new(nil, 0, 0, w, h, palette.darkest, true)
    local overlay = Node.new(root, 0, 0, w, h, Color(0.0, 0.0, 0.0, 0.0), true)
    fps = Node.text(overlay, 60, 20, 15, 32, palette.gizmoRed, true, false)

    love.mouse.setCursor(love.mouse.newCursor(love.image.newImageData("resources/textures/cursor.png"), 0, 0))

    ---- MENU
    -- local menuW, menuH = 500, 400
    -- local menu = Node.new(root, w / 2 - menuW / 2, h / 2 - menuH / 2, menuW, menuH, Color(0,0,0,0), false)

    -- local play = Node.text(menu, "Play", w / 2, h / 2 - 32, 64, palette.bright, false, true)
    -- local function playAction()
    --     play.setText("PLAY")
    -- end
    -- play.setAction(playAction)

    -- local settings = Node.text(menu, "Settings", w / 2, h / 2 + 32, 64, palette.brightest, false, true)

    ---- GAMEPLAY

    mainPlanet = Planet.new(root, w / 2, h / 2, 128)

    planets = {}

    for i = 1,20 do 
        local x = love.math.random() * w
        local y = love.math.random() * h
        local m = love.math.random() * 28 + 4
        planets[i] = Planet.new(root, x, y, m)
    end
end

function love.draw()
    Node.drawAll()
end

function love.update(dt)
    fps.setText(love.timer.getFPS())

    local function dist2(x1, y1, x2, y2)
        return x1 * y1 + x2 * y2
    end

    for i = 1,20 do
        local p1 = planets[i]
        local ax, ay = 0, 0
        for j = i,20 do
            local p2 = planets[j]
            local dist = dist2(p1.x, p1.y, p2.x, p2.y)
            if dist > p1.m + p2.m then 
                local f = p1.m * p2.m / dist

                local dx, dy = p2.x - p1.x, p2.y - p1.y
                local a = math.atan2(dy, dx)

                ax = ax + f * math.cos(a)
                ay = ay + f * math.sin(a)
            end
        end

        local p2 = mainPlanet
        local dist = dist2(p1.x, p1.y, p2.x, p2.y)
        if dist > p1.m + p2.m then
            local f = p1.m * p2.m / dist

            local dx, dy = p2.x - p1.x, p2.y - p1.y
            local a = math.atan2(dy, dx)

            ax = ax + f * math.cos(a)
            ay = ay + f * math.sin(a)
        end

        p1.ax = ax
        p1.ay = ay
    end

    for i = 1,20 do 
        planets[i].updatePhysics(dt)
    end

    Node.updateAll(dt)
end

function love.mousepressed(_, _, _)
    Node.updateMouseButtonEvent(true)
end

function love.mousereleased(_, _, _)
    Node.updateMouseButtonEvent(false)
end