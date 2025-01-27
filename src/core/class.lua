-- look up for `k' in list of tables `plist'
local function search(k, plist)
    for i = 1, #plist do
        local v = plist[i][k]     -- try `i'-th superclass
        if v then return v end
    end
end

function CreateClass(...)
    local class = {} -- new class
    local parents = {...}

    -- class will search for each method in the list of its parents
    setmetatable(
        class,
        {
            __index = function(t, k)
                return search(k, parents)
            end
        }
    )

    -- prepare `class' to be the metatable of its instances
    class.__index = class

    -- define a new constructor for this new class
    function class:new(o)
        o = o or {}
        setmetatable(o, class)
        return o
    end

    -- return new class
    return class
end

-- -- Example

-- Account = CreateClass()
-- Account.balance = 444

-- function Account:deposit (v)
--     self.balance = self.balance + v
-- end

-- function Account:withdraw (v)
--     if v > self.balance then error"insufficient funds" end
--     self.balance = self.balance - v
-- end

-- local a = Account:new{}

-- print(a.balance)
-- a:deposit(100)
-- print(a.balance)
-- a:withdraw(200)
-- print(a.balance)

-- SpecialAccount = CreateClass(Account)

-- function SpecialAccount:withdraw(v)
--     if v - self.balance >= self:getLimit() then
--         error"insufficient funds"
--     end
--     self.balance = self.balance - v
-- end

-- function SpecialAccount:getLimit()
--     return self.limit or 0
-- end

-- local s = SpecialAccount:new{balance = 500, limit = 1000}
-- print(s.balance)
-- print(s:getLimit())

-- Named = CreateClass()

-- function Named:getname ()
--     return self.name
-- end

-- function Named:setname(n)
--     self.name = n
-- end

-- NamedAccount = CreateClass(Account, Named)

-- local account = NamedAccount:new({name = "Paul"})
-- print(account:getname())     --> Paul