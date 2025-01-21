require("core/list")

Shader = {}

Shader.new = function(shaderName)
    local self = {}

    self.id = shaderName
    self.shader = love.graphics.newShader("resources/shaders/"..shaderName..".glsl")
    self.parameters = List.new()

    self.setParameter = function(name, value, array)
        self.parameters.append({name = name, value = value, array = array})
    end

    self.setActive = function(active)
        if active then
            Logger.notice("Shader "..self.id.." is on!")
            love.graphics.setShader(self.shader)
        else
            Logger.notice("Shader "..self.id.." is off!")
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