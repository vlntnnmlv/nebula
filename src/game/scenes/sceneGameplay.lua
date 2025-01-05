dofile("src/game/cosmos.lua")

local sceneGameplay = Scene.new("Gameplay")

local root = Node.new(sceneGameplay, nil, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
root.setColor(Color(0.117, 0.109, 0.223, 1.0))
root.ignoreEvents = true

Cosmos.new(sceneGameplay, root, SCREEN_WIDTH, SCREEN_HEIGHT)

local overlay = Node.new(sceneGameplay, root, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
overlay.setColor(Color(1.0, 1.0, 1.0, 0.0))
overlay.ignoreEvents = true

FPS.new(sceneGameplay, overlay, 20, 15, 32).setColor(Palette.gizmoRed)
local backButton =  Node.text(sceneGameplay, overlay, "Menu", SCREEN_WIDTH - 50, SCREEN_HEIGHT - 30, 32, true)
backButton.setColor(Palette.brightest)

local function backAction(pressed)
    if pressed then return end
    Scene.switchScene("Menu")
end
backButton.setAction(backAction)