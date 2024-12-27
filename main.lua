dofile("src/node.lua")

function love.load()
    -- Node.drawGizmos = true
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setFont(love.graphics.newFont("resources/fonts/alagard.ttf", 32))

    local w, h = 1080, 720

    local root = Node.new(nil, 0, 0, w, h, palette.darkest, true)
    local overlay = Node.new(root, 0, 0, w, h, Color(0.0, 0.0, 0.0, 0.0), true)
    fps = Node.text(overlay, 60, 20, 15, 32, palette.gizmo, true, false)

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
    planet = Node.image(root, w / 2 - 64, h / 2 - 64, 128, 128, "resources/textures/sphere.png", "resources/shaders/shine.glsl", Color(1,1,1,1), false)
end

function love.draw()
    Node.drawAll()
end

function love.update(dt)
    fps.text = love.timer.getFPS()

    Node.updateAll(dt)
end

function love.mousepressed(_, _, _)
    Node.updateMouseButtonEvent(true)
end

function love.mousereleased(_, _, _)
    Node.updateMouseButtonEvent(false)
end