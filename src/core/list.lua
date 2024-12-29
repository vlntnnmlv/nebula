local function getValueString(value)
    if type(value) == "table" then
        if value.toString == nil then
            return "table"
        else
            return value.toString(value)
        end
    end
    
    return tostring(value)
end

List = {}
-- N <-> N <-> N --

List.append = function(list, value)
    local result = { value = value, prev = list, next = nil }

    if list ~= nil then
        local cur = list
        while cur.next ~= nil do cur = cur.next end
        cur.next = result
    end

    return result
end

List.apply = function(list, func)
    local cur = list
    while cur ~= nil do
        func(cur.value)
        cur = cur.next
    end
end

List.applyUntil = function(list, func, condition)
    local cur = list
    local tempResult = nil
    while cur ~= nil do
        tempResult = func(cur.value)
        if condition(tempResult) then return tempResult end
        cur = cur.next
    end
end

List.remove = function(node)
    local result = node.next

    if node.prev ~= nil then
        node.prev.next = node.next
    end

    if node.next ~= nil then
        node.next.prev = node.prev
    end

    node.prev = nil
    node.next = nil
    node = nil

    return result
end

List.filter = function(list, func, first)
    local result = list
    local cur = list
    while cur ~= nil do
        if func(cur.value) then
            if result == cur then
                result = cur.next
            end
            cur = List.remove(cur)
            if first then return result end
        else
            cur = cur.next
        end
    end

    return result
end

List.dump = function(list)
    if list == nil then io.write("nil\n") return end

    local cur = list
    io.write("nil<-")
    while cur ~= nil do
        if cur.next == nil then
            io.write(getValueString(cur.value).."->")
        else
            io.write(getValueString(cur.value).."<->")
        end
        cur = cur.next
    end
    io.write("nil\n")
end