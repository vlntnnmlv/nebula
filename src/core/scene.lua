Scene = CreateClass()

Scene.drawGizmos = false
Scene.current = nil
Scene.data = {}

function Scene.switchScene(id)
    if id == nil then
        Logger.warning("No scene specified. Setting to default...")
    elseif Scene.data[id] == nil then
        Logger.error("No such scene: "..id.."!")
    else
        Scene.current = Scene.data[id]
        Logger.success("Scene loaded: "..id.."!")
    end
end

function Scene.loadScenes(scenesDir)
    for _, scene in pairs(love.filesystem.getDirectoryItems(scenesDir)) do
        dofile(scenesDir.."/"..scene)
    end

    Logger.success("Scenes loaded!")

    local backupScene = Scene.create("BackupScene404")
    local root = Node.create(backupScene, nil, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

    Text.create(backupScene, root, "404", SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2 - 32, 64)
        :setColor(Palette.gizmoRed)
    Text.create(backupScene, root, "Set a scene using Scene.switchScene(sceneID)", SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2 + 32, 24)
        :setColor(Palette.gizmoRed)

    Scene.current = backupScene
    Logger.success("Backup scene set!")
end

function Scene:init(id)
    self.id = id
    self.data[id] = self

    self.gizmoCanvas = love.graphics.newCanvas(SCREEN_WIDTH, SCREEN_HEIGHT, { format = "rgba8", mipmaps = "none"})

    self.nodes = {}
    self.nodesCount = 0
    self.hoveredElement = nil

    self.scale = 1
    self.offsetX = 0
    self.offsetY = 0

    self.pressedElement = nil
end

function Scene:registerNode(node)
    node.id = self.nodesCount

    self.nodesCount = self.nodesCount + 1

    self.nodes[node.id] = node
end

function Scene:drawAll()
    if self.nodesCount == 0 then return end

    love.graphics.setCanvas(self.gizmoCanvas)
    love.graphics.clear()
    love.graphics.setCanvas()

    love.graphics.clear()
    self.nodes[0]:draw()

    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
    love.graphics.draw(self.gizmoCanvas, 0, 0)
end

function Scene:updateAll()
    if self.nodesCount == 0 then return end

    self.nodes[0]:update()

    if self.hoveredElement == nil then return end

    if self.pressedElement ~= nil then
        self.pressedElement:updateKeys()
    end
end

function Scene:updateMouseButtonEvent(pressed)
    if self.nodesCount == 0 then return end

    self.nodes[0]:update(0)

    if self.hoveredElement == nil then return end
    self.pressedElement = self.hoveredElement

    if pressed then
        self.pressedElement:action(pressed)
    end

    if not pressed and self.pressedElement ~= nil and self.pressedElement.id == self.hoveredElement.id then
        self.pressedElement:action(pressed)
    end
end