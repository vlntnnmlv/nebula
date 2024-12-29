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

List.append = function(node, value)
    node.next = { value = value, prev = node, next = nil}
    return node.next
end

List.dump = function(list)
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