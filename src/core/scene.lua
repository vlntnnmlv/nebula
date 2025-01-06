dofile("src/core/node.lua")

Scene = {}

Scene.drawGizmos = false
Scene.current = nil
Scene.data = {}

Scene.switchScene = function(id)
    if Scene.data[id] == nil then
        print("No such scene!")
    else
        Scene.current = Scene.data[id]
    end
end

Scene.loadScenes = function(scenesDir)
    for _, scene in pairs(love.filesystem.getDirectoryItems(scenesDir)) do
        dofile(scenesDir.."/"..scene)
    end

    local backupScene = Scene.new("BackupScene404")
    local root = Node.new(backupScene, nil, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    Node.text(backupScene, root, "404", SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2 - 32, 64, false)
        .setColor(Palette.gizmoRed)
    Node.text(backupScene, root, "Set a scene using Scene.switchScene(sceneID)", SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2 + 32, 24, false)
        .setColor(Palette.gizmoRed)

    Scene.current = backupScene
end

Scene.new = function(id)
    local self = {}

    self.id = id
    Scene.data[id] = self

    self.nodes = {}
    self.nodesCount = 0
    self.focusElement = nil
    self.pressedElement = nil

    self.registerNode = function(node)
        node.id = self.nodesCount

        self.nodesCount = self.nodesCount + 1

        self.nodes[node.id] = node
    end

    self.drawAll = function()
        if self.nodesCount == 0 then return end

        self.nodes[0].draw()
    end

    self.updateAll = function(dt)
        if self.nodesCount == 0 then return end

        self.nodes[0].update(dt)
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