---@diagnostic disable: deprecated
Shader = CreateClass()
Shader.count = 1

function Shader.create(name)
    local shader = Shader:new()

    shader:init(name)

    return shader
end

function Shader:init(name)
    self.i = 0
    self.id = Shader.count
    Shader.count = Shader.count + 1

    self.name = name
    self.shader = love.graphics.newShader("resources/shaders/"..self.name..".glsl")
    self.parameters = List.new()
end

function Shader:setParameter(name, value, array)
    self.parameters.append({name = name, value = value, lastValue = nil, array = array})
end

function Shader:setActive(active)
    if active then
        love.graphics.setShader(self.shader)
    else
        love.graphics.setShader()
    end
end

function Shader:update()
    if self.parameters.len == 0 or self.shader == nil then return end

    self.parameters.apply(
        function(paramater)
            local valueToSet = nil
            if type(paramater.value) == "function" then
                valueToSet = paramater.value()
            else
                valueToSet = paramater.value
            end

            if paramater.lastValue == valueToSet then return end

            if paramater.array ~= nil then
                self.shader:send(paramater.name, unpack(valueToSet))
            else
                self.shader:send(paramater.name, valueToSet)
            end

            paramater.lastValue = valueToSet
        end
    )
end