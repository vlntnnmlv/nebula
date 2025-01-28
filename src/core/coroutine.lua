-- TODO: Add coroutines system

-- Coroutine = CreateClass()
-- Coroutine.coroutines = List.new()
-- Coroutine.currentID = nil
-- Coroutine.nextID = 0

-- function Coroutine.create(yieldable)
--     local coroutine = Coroutine:new()

--     coroutine.yieldable = yieldable
--     coroutine.id = coroutine.nextID
--     coroutine.nextID = coroutine.nextID + 1

--     return coroutine
-- end

-- function Coroutine.update()
--     if Coroutine.currentID == nil and Coroutine.coroutines.head ~= nil then
--         Coroutine.currentID = Coroutine.coroutines.head.id
--     end

--     if Coroutine.currentID == nil then return end
-- end

-- function Coroutine:yield()

-- end