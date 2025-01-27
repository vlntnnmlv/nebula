Image = CreateClass(Node)

function Image.create(scene, parent, x, y, w, h, texture)
    local image = Image:new()

    image:init(scene, parent, x, y, w, h, texture)

    return image
end

function Image:init(scene, parent, x, y, w, h, texture)
    Node.init(self, scene, parent, x, y, w, h)

    self.imageData = love.image.newImageData("resources/textures/"..texture)
    self.image = love.graphics.newImage(self.imageData)

    self.scaleX = self.w / self.imageData:getWidth()
    self.scaleY = self.h / self.imageData:getHeight()
    self.rotation = 0
    self.originOffsetX = self.imageData:getWidth() / 2
    self.originOffsetY = self.imageData:getHeight() / 2
    self.shearX = 0
    self.shearY = 0
end

function Image:resize(newW, newH)
    Node.resize(self, newW, newH)

    self.scaleX = self.w / self.imageData:getWidth()
    self.scaleY = self.h / self.imageData:getHeight()
end

function Image:drawInternal()
    love.graphics.draw(self.image, 0 + self.w / 2, 0 + self.h / 2, self.rotation, self.scaleX, self.scaleY, self.originOffsetX, self.originOffsetY, self.shearX, self.shearY)
end

function Image:rotate(rotation)
    self.rotation = self.rotation + rotation
end