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

local ListNode = {}

ListNode.new = function(value)
    local self = { value = value, next = nil, prev = nil }
    return self
end

-- N <-> N <-> N --
List = {}

List.new = function()
    local self = {}

    self.head = nil
    self.tail = nil
    self.len = 0

    self.dump = function()
        local stringView = ""

        stringView = stringView.."L<"..self.len.."> "
        if self.head == nil then io.write("nil\n") return end

        local cur = self.head
        stringView = stringView.."nil<-"
        while cur ~= nil do
            if cur.next == nil then
                stringView = stringView..getValueString(cur.value).."->"
            else
                stringView = stringView..getValueString(cur.value).."<->"
            end
            cur = cur.next
        end
        stringView = stringView.."nil"
        Logger.notice(stringView)
    end

    self.append = function(value)
        if self.head == nil then
            self.head = ListNode.new(value)
            self.tail = self.head
        else
            self.tail.next = ListNode.new(value)
            self.tail.next.prev = self.tail
            self.tail = self.tail.next
        end

        self.len = self.len + 1
    end

    self.remove = function(node)
        local result = node.next

        if node == self.head then
            self.head = node.next
        end

        if node == self.tail then
            self.tail = node.prev
        end

        if node.prev ~= nil then
            node.prev.next = node.next
        end

        if node.next ~= nil then
            node.next.prev = node.prev
        end

        node.prev = nil
        node.next = nil
        node.value = nil
        node = nil

        self.len = self.len - 1

        return result
    end

    self.filter = function(func, first)
        local cur = self.head
        while cur ~= nil do
            if func(cur.value) then
                cur = self.remove(cur)
                if first then return end
            else
                cur = cur.next
            end
        end
    end

    self.apply = function(func)
        local cur = self.head
        while cur ~= nil do
            func(cur.value)
            cur = cur.next
        end
    end

    self.applyUntil = function(func, condition)
        local cur = self.head
        local tempResult = nil
        while cur ~= nil do
            tempResult = func(cur.value)
            if condition(tempResult) then return tempResult end
            cur = cur.next
        end
    end

    return self
end