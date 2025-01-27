Image = CreateClass(Node)

function Image:create(scene, parent, x, y, w, h, texture)
    local image = Image:new()

    image.init()

    return image
end