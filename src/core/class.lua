function AssembleClass(classConstructor, classMethods, parentClass)
    local class = {}

    class.methods = classMethods

    class.base = function(...)
        local base = nil
        if parentClass == nil then
            base = {}
        else
            base = parentClass.new(...)
        end

        return base
    end

    class.new = function(...)
        local self = class.base(...)

        for name, func in pairs(class.methods) do
            if self[name] ~= nil then
                self[name.."Base"] = self[name]
                self[name] = nil
            end

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

-- local numbermethods = {
--     log = function(this) print("N Log "..this.number) end,
--     add = function(this, number) return this.number + number end,
--     sub = function(this, number) return this.number - number end,
--     mult = function(this, number) return this.number * number end,
--     div = function(this, number) return this.number / number end
-- }

-- local numberconstructor = function(this, number)
--     print("number constructor")
--     this.number = number
-- end

-- Number = AssembleClass(numberconstructor, numbermethods)

-- local n = Number.new(4)

-- n.log()
-- print(n.add(1))
-- print(n.sub(1))
-- print(n.mult(4))
-- print(n.div(4))

-- local numberstringconstructor = function(this, number, str)
--     print("numberstring constructor")
--     this.str = str
-- end

-- local numberstringmethods = {
--     log = function(this)
--         this.logBase()
--         print("NS Log "..this.number.." "..this.str)
--     end,
-- }

-- NumberString = AssembleClass(numberstringconstructor, numberstringmethods, Number)

-- local ns = NumberString.new(10, "Hi")

-- ns.log()
-- print(ns.add(1))
-- print(ns.sub(1))
-- print(ns.mult(4))
-- print(ns.div(4))