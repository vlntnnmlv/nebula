dofile("src/node.lua")

function love.load()
    Node.drawGizmos = true
    love.graphics.setFont(love.graphics.newFont("resources/fonts/alagard.ttf", 32))

    local w, h = 1080, 720

    local root = Node.new(nil, 0, 0, w, h, palette.ebony, true)
    fps = Node.text(root, 60, 20, 15, 32, palette.red, true)
    cursor = Node.new(root, 0, 0, 4, 4, palette.cambridgeBlue, true)

    local menuW, menuH = 500, 400
    local menu = Node.new(root, w / 2 - menuW / 2, h / 2 - menuH / 2, menuW, menuH, palette.sunset, false)

    local play = Node.text(menu, "Play", w / 2, h / 2 - 32, 64, palette.atomicTangerine, false)
    local function playAction()
        play.text = "PLAY"
    end
    play.setAction(playAction)

    local settings = Node.text(menu, "Settings", w / 2, h / 2 + 32, 64, palette.atomicTangerine, false)
end

function love.draw()
    Node.drawAll()
end

function love.update(dt)
    fps.text = love.timer.getFPS()

    cursor.x = love.mouse.getX() - 2
    cursor.y = love.mouse.getY() - 2

    Node.updateAll(dt)
end

function love.mousepressed(x, y, button)
    Node.updateMouseButtonEvent(true, x, y)
end

function love.mousereleased(x, y, button)
    Node.updateMouseButtonEvent(false, x, y)
end