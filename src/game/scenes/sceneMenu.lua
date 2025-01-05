dofile("src/game/fps.lua")

local sceneMenu = Scene.new("Menu")

local root = Node.new(sceneMenu, nil, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
root.setColor(Palette.darkest)
root.ignoreEvents = true

local menuW, menuH = 500, 400
local menu = Node.new(sceneMenu, root, SCREEN_WIDTH / 2 - menuW / 2, SCREEN_HEIGHT / 2 - menuH / 2, menuW, menuH)
menu.setColor(Color(0,0,0,0))

local play = Node.text(sceneMenu, menu, "Play", SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2 - 32, 64, true)
play.setColor(Palette.bright)

local function playAction(pressed)
    if pressed then return end
    Scene.switchScene("Gameplay")
end
play.setAction(playAction)

Node.text(sceneMenu, menu, "Settings", SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2 + 32, 64, true).setColor(Palette.brightest)

local overlay = Node.new(sceneMenu, root, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
overlay.setColor(Color(0, 0, 0, 0))
overlay.ignoreEvents = true

FPS.new(sceneMenu, overlay, 20, 15, 32).setColor(Palette.gizmoRed)

local eye = Node.image(sceneMenu, overlay, SCREEN_WIDTH / 2 - 64, 100, 128, 128, "resources/textures/eye.png")
eye.setColor(Color(1,1,1,1))

eye.setAction(
    function(pressed)
        if pressed then
            eye.setSize(64, 64)
            eye.x = SCREEN_WIDTH / 2 - 32
            eye.y = 132
        else
            eye.setSize(128, 128)
            eye.x = SCREEN_WIDTH / 2 - 64
            eye.y = 100
        end
    end
)
