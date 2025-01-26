require("core/class")
require("core/list")
require("core/palette")
require("core/shader")

Node = CreateClass()

-- TODO:
-- This are default values for Node object.
-- However, must not assign tables here, because it's gonna be common among all Node object.
-- Find out how to properly store static variables, and a better way to set default values.
-- (Move this to init method?)
Node.scene = nil
Node.parent = nil
Node.children = nil
Node.ignoreEvents = false
Node.active = true
Node.keyActions = nil
Node.w = 0
Node.h = 0
Node.x = 0
Node.y = 0
Node.canvas = nil
Node.shader = nil
Node.color = nil

function Node.create(scene, parent, x, y, w, h)
    local node = Node:new()

    node:init(scene, parent, x, y, w, h)

    return node
end

function Node:init(scene, parent, x, y, w, h)
    self.scene = scene
    self.parent = parent
    self.children = List.new()
    self.keyActions = nil

    if self.parent ~= nil then
        self.parent:linkChild(self)
    end

    self.scene:registerNode(self)

    self.w = w
    self.h = h
    self.x = x
    self.y = y

    self.canvas = love.graphics.newCanvas(self.w, self.h, { format = "rgba8" })
    self.shader = Shader.create("image")
    self:setColor(Color(1.0, 1.0, 1.0, 1.0))
end

-- UI Tree
function Node:linkChild(child)
    self.children.append(child)
end

function Node:remove()
    self.parent.children.filter(function(node) return node.id == self.id end, true)
end

function Node:getParentID()
    if self.parent == nil then return nil end

    return self.parent.id
end

-- Events processing
function Node:updateInternal(dt) end

function Node:update(dt)
    if not self.active then return end

    if self.shader ~= nil then self.shader:update() end

    self:updateInternal(dt)

    self:updateState(dt)
end

function Node:updateChildren(dt)
    self.children.apply(function(child) return child:update(dt) end)
end

function Node:updateState(dt)
    if self.ignoreEvents then return false end

    local mouseX, mouseY = love.mouse.getPosition()
    if mouseX > self.x and mouseX < self.x + self.w and mouseY > self.y and mouseY < self.y + self.h then
        self.scene.focusElement = self
    end

    self:updateChildren(dt)
end

function Node:setKeyAction(key, action)
    self.keyActions[key] = action
end

function Node:updateKeys()
    for key, action in pairs(self.keyActions) do
        if Keys.held[key] then
            action()
        end
    end
end

function Node:setAction(action)
    self.action = action
end

-- Rendering
function Node:setColor(color)
    self.color = color

    if self.shader ~= nil then
        self.shader:setParameter("iColor", { color.r, color.g, color.b, color.a })
    end
end

function Node:setSize(newW, newH)
    self.w = newW
    self.h = newH

    local cw, ch = 1, 1
    if self.w > 1 then cw = self.w end
    if self.h > 1 then ch = self.h end

    self.canvas:release()
    self.canvas = love.graphics.newCanvas(cw, ch)
end

function Node:setShader(shader)
    self.shader = Shader:new(shader)
end

function Node:setShaderActive(active)
    if self.shader == nil then return end

    self.shader:setActive(active)
end

function Node:draw()
    if not self.active then return end

    love.graphics.setCanvas(self.canvas) -- set render target to self canvas
    love.graphics.clear() -- clear self canvas to complete transparancy

    love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a) -- set render color to self color
    self:drawInternal() -- draw self to self canvas

    love.graphics.setCanvas()

    -- render children
    self.children.apply(
        function(child)
            child:draw() -- render child to it's canvas
            love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
            love.graphics.setCanvas(self.canvas) -- render child canvas to self canvas
            child:setShaderActive(true)
            love.graphics.draw(child.canvas, child.x - self.x, child.y - self.y)
            child:setShaderActive(false)
            love.graphics.setCanvas()
        end
    )

    -- render to the screen if self is root node
    if self.parent == nil then
        love.graphics.setCanvas()
        love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
        self:setShaderActive(true)
        love.graphics.draw(self.canvas, self.x, self.y)
        self:setShaderActive(false)
    end

    if Scene.drawGizmos then
        love.graphics.setCanvas(self.scene.gizmoCanvas)
        self:drawGizmo()
        love.graphics.setCanvas()
    end
end

function Node:drawInternal()
    love.graphics.polygon(
        "fill",
        0, 0,
        0 + self.w - 1, 0,
        0 + self.w - 1, 0 + self.h - 1,
        0, 0 + self.h - 1
    )
end

function Node:drawGizmo()
    -- NOTE: There is something weird with window size, as it is bigger by one pixel than it should've been.
    -- NOTE: Also, I  don't know how lines are actualy rendered in polygon, seems like it's trying to fade alpha out near the edges.
    love.graphics.setColor(Palette.gizmoRed.r, Palette.gizmoRed.g, Palette.gizmoRed.b, Palette.gizmoRed.a)
    love.graphics.setLineWidth(2)
    love.graphics.polygon(
        "line",
        1 + self.x, 1 + self.y,
        self.x + self.w - 1, 1 + self.y,
        self.x + self.w - 1, self.y + self.h - 1,
        1 + self.x, self.y + self.h - 1
    )

    love.graphics.print(self.id, self.x + self.w - 20, self.y + 4)

    if self.scene.focusElement == self then
        love.graphics.circle("fill", self.x + 9, self.y + 9, 5)
    end

    love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
end

-- Node.text = function(scene, parent, text, cx, cy, fontSize)
--     -- TODO: Clean self mess, why we are calculating self two times?
--     local font = love.graphics.newFont("resources/fonts/alagard.ttf", fontSize)

--     local w = font:getWidth(text)
--     local h = font:getHeight(text)
--     local self = Node.new(scene, parent, cx, cy, w, h)

--     self.shader = nil

--     self.restore = function()
--         self.w = self.font:getWidth(self.text)
--         self.h = self.font:getBaseline(self.text)
--         self.x = self.cx - self.w / 2
--         self.y = self.cy - self.h / 2
--     end

--     self.text = text
--     self.font = font
--     self.cx = cx
--     self.cy = cy

--     self.restore()

--     self.setText = function(text)
--         self.text = text

--         self.restore()
--     end

--     self.drawInternal = function()
--         love.graphics.setFont(self.font)
--         love.graphics.print(self.text, 0, 0)
--     end

--     return self
-- end

Node.image = function(scene, parent, x, y, w, h, image)
    local self = Node.new(scene, parent, x, y, w, h)
    self.shader = Shader:new("image")

    self.imageData = love.image.newImageData("resources/textures/"..image)
    self.image = love.graphics.newImage(self.imageData)

    self.scaleX = self.w / self.imageData:getWidth()
    self.scaleY = self.h / self.imageData:getHeight()
    self.rotation = 0
    self.originOffsetX = self.imageData:getWidth() / 2
    self.originOffsetY = self.imageData:getHeight() / 2
    self.shearX = 0
    self.shearY = 0

    local setSizeBase = self.setSize
    self.setSize = function(newW, newH)
        setSizeBase(newW, newH)

        self.scaleX = self.w / self.imageData:getWidth()
        self.scaleY = self.h / self.imageData:getHeight()
    end

    self.drawInternal = function()
        Logger.notice("Draw image")
        love.graphics.draw(self.image, 0 + self.w / 2, 0 + self.h / 2, self.rotation, self.scaleX, self.scaleY, self.originOffsetX, self.originOffsetY, self.shearX, self.shearY)
    end

    self.rotate = function(rotation)
        self.rotation = self.rotation + rotation
    end

    return self
end