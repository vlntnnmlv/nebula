dofile("src/core/list.lua")

Shader = {}

Shader.new = function(shaderName)
    local self = {}

    self.shader = love.graphics.newShader("resources/shaders/"..shaderName..".glsl")
    self.parameters = List.new()

    self.setParameter = function(name, value, array)
        self.parameters.append({name = name, value = value, array = array})
    end

    self.setActive = function(active)
        if active then
            love.graphics.setShader(self.shader)
        else
            love.graphics.setShader()
        end
    end

    self.update = function()
        if self.parameters.len == 0 or self.shader == nil then return end

        self.parameters.apply(
            function(paramater)
                local valueToSet = nil
                if type(paramater.value) == "function" then
                    valueToSet = paramater.value()
                else
                    valueToSet = paramater.value
                end

                if paramater.array ~= nil then
                    self.shader:send(paramater.name, unpack(valueToSet))
                else
                    self.shader:send(paramater.name, valueToSet)
                end
            end
        )
    end

    return self
end