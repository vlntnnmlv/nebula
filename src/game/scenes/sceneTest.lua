local sceneTest = Scene.new("Test")

Logger.warning(SCREEN_WIDTH.."  "..SCREEN_HEIGHT)
local root = Node.new(sceneTest, nil, 0, 0, SCREEN_WIDTH + 1, SCREEN_HEIGHT + 1)
root.setColor(Color(0.0, 0.5, 0.5, 1.0))