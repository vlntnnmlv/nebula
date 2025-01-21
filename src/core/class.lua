function AssembleClass(classConstructor, classMethods)
    local class = {}

    class.methods = classMethods

    class.new = function(...)
        local self = {}

        for name, func in pairs(class.methods) do
            self[name] = function(...)
                return func(self, ...)
            end
        end

        classConstructor(self, ...)

        return self
    end

    return class
end

---- Example

local methods = {
    log = function(this) print(this.number) end,
    add = function(this, number) return this.number + number end,
    sub = function(this, number) return this.number - number end,
    mult = function(this, number) return this.number * number end,
    div = function(this, number) return this.number / number end
}

local constructor = function(self, number)
    self.number = number
end

Number = AssembleClass(constructor, methods)

local n = Number.new(4)

print(n.add(1))
print(n.sub(1))
print(n.mult(4))
print(n.div(4))