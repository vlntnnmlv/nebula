require("core/node/node")

Scene = {}

Scene.drawGizmos = false
Scene.current = nil
Scene.data = {}

Scene.switchScene = function(id)
    if id == nil then
        Logger.warning("No scene specified. Setting to default...")
    elseif Scene.data[id] == nil then
        Logger.error("No such scene: "..id.."!")
    else
        Scene.current = Scene.data[id]
        Logger.success("Scene loaded: "..id.."!")
    end
end

Scene.loadScenes = function(scenesDir)
    for _, scene in pairs(love.filesystem.getDirectoryItems(scenesDir)) do
        dofile(scenesDir.."/"..scene)
    end

    Logger.success("Scenes loaded!")

    local backupScene = Scene.new("BackupScene404")
    local root = Node.new(backupScene, nil, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    Node.text(backupScene, root, "404", SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2 - 32, 64)
        .setColor(Palette.gizmoRed)
    Node.text(backupScene, root, "Set a scene using Scene.switchScene(sceneID)", SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2 + 32, 24)
        .setColor(Palette.gizmoRed)

    Scene.current = backupScene
    Logger.success("Backup scene set!")
end

Scene.new = function(id)
    local self = {}

    self.id = id
    Scene.data[id] = self

    self.gizmoCanvas = love.graphics.newCanvas(SCREEN_WIDTH, SCREEN_HEIGHT, { format = "rgba8", mipmaps = "none"})

    self.nodes = {}
    self.nodesCount = 0
    self.focusElement = nil

    self.scale = 1
    self.offsetX = 0
    self.offsetY = 0

    self.pressedElement = nil

    self.registerNode = function(node)
        node.id = self.nodesCount

        self.nodesCount = self.nodesCount + 1

        self.nodes[node.id] = node
    end

    self.drawAll = function()
        if self.nodesCount == 0 then return end

        love.graphics.setCanvas(self.gizmoCanvas)
        love.graphics.clear()
        love.graphics.setCanvas()

        love.graphics.clear()
        self.nodes[0].draw()

        love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
        love.graphics.draw(self.gizmoCanvas, 0, 0)
    end

    self.updateAll = function(dt)
        if self.nodesCount == 0 then return end

        self.nodes[0].update(dt)

        if self.focusElement == nil then return end

        self.focusElement.updateKeys()
    end

    self.updateMouseButtonEvent = function(pressed)
        if self.nodesCount == 0 then return end

        self.nodes[0].update(0)

        if self.focusElement == nil or self.focusElement.action == nil then return end

        if pressed then
            self.pressedElement = self.focusElement
            self.focusElement.action(pressed)
        end

        if not pressed and self.pressedElement ~= nil and self.pressedElement.id == self.focusElement.id and self.focusElement.action ~= nil then
            self.focusElement.action(pressed)
        end
    end

    return self
end