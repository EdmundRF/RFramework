local List_Node = {}

List_Node.value = nil
List_Node.next = nil
List_Node.prev = nil

function List_Node:New(object)
  object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end

List_Iterator = {}
List_Iterator.node = nil
List_Iterator.owner = nil

function List_Iterator:New(_owner)
  local object = {}
  setmetatable(object, self)
  self.__index = self
  object.owner = _owner
  return object
end

function List_Iterator:Next(count)
  count = count or 1
  for i = 1, count do
    if self.node ~= nil then
      self.node = self.node.next
    else
      return false
    end
  end
  return self.node ~= nil
end

function List_Iterator:Prev(count)
  count = count or 1
  for i = 1, count do
    if self.node ~= nil then
      self.node = self.node.prev
    else
      return false
    end
  end
  return self.node ~= nil
end

function List_Iterator:Value()
  if self.node ~= nil then
    return self.node.value
  end
  return nil
end

function List_Iterator:Erase()
  if self.owner ~= nil then
    return self.owner:Erase(self)
  end
end

function List_Iterator:Valid()
  return self.owner ~= nil and self.node ~= nil
end

List = {}
List.first = nil
List.last = nil

function List:New(object)
  object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end

function List:PushBack(value)
  if nil == self.last or nil == self.first then
    self.first = List_Node:New()
    self.last = self.first
    self.last.value = value
    return
  end
  local NewNode = List_Node:New()
  NewNode.prev = self.last
  NewNode.value = value
  self.last.next = NewNode
  self.last = NewNode
end

function List:PopBack()
  if nil == self.last then
    return nil
  end
  local back = self:Back()
  local prevNode = self.last.prev
  if prevNode == nil then
    self.first = nil
    self.last = nil
  else
    prevNode.next = nil
    self.last = prevNode
  end
  return back
end

function List:PushFront(value)
  if nil == self.first or nil == self.last then
    self.first = List_Node:New()
    self.last = self.first
    self.last.value = value
    return
  end
  local NewNode = List_Node:New()
  NewNode.value = value
  NewNode.next = self.first
  self.first.prev = NewNode
  self.first = NewNode
end

function List:PopFront()
  if nil == self.first then
    return nil
  end
  local front = self:Front()
  local nextNode = self.first.next
  if nextNode == nil then
    self.first = nil
    self.last = nil
  else
    nextNode.prev = nil
    self.first = nextNode
  end
  return front
end

function List:Front()
  if self.first ~= nil then
    return self.first.value
  end
  return nil
end

function List:Back()
  if self.last ~= nil then
    return self.last.value
  end
  return nil
end

function List:Empty()
  return nil == self.first or nil == self.last
end

function List:Clear()
  self.first = nil
  self.last = nil
end

function List:Begin()
  local itr = List_Iterator:New(self)
  itr.node = self.first
  return itr
end

function List:End()
  local itr = List_Iterator:New(self)
  itr.node = self.last
  return itr
end

function List:Find(v, start)
  if start == nil then
    start = self:Begin()
  end
  repeat
    if v == start:Value() then
      return start
    end
  until start:Next() == false
  return nil
end

function List:FindLast(v, start)
  if start == nil then
    start = self:End()
  end
  repeat
    if v == start:Value() then
      return start
    end
  until start:Prev() == false
  return nil
end

function List:Erase(itr)
  if nil == itr or nil == itr.node or itr.owner ~= self then
    return itr
  end
  local nextItr = List_Iterator:New(self)
  nextItr.node = itr.node
  nextItr:Next()
  if itr.node == self.first then
    self:PopFront()
  elseif itr.node == self.last then
    self:PopBack()
  else
    local prevNode = itr.node.prev
    local nextNode = itr.node.next
    if prevNode ~= nil then
      prevNode.next = nextNode
    end
    if nextNode ~= nil then
      nextNode.prev = prevNode
    end
  end
  itr.owner = nil
  itr.node = nil
  return nextItr
end

function List:EraseValue(value)
  local itr = self:Find(value)
  self:Erase(itr)
end

function List:EraseAll(value)
  local itr = self:Find(value)
  while itr ~= nil and itr:Valid() do
    itr = self:Erase(itr)
    itr = self:Find(value, itr)
  end
end

function List:Insert(itr, value)
  if nil == itr or nil == itr.node or itr.owner ~= self then
    return
  end
  local result_itr = List_Iterator:New(self)
  if itr.node == self.last then
    self:PushBack(value)
    result_itr.node = self.last
  else
    local prevNode = itr.node
    local nextNode = itr.node.next
    local NewNode = List_Node:New()
    NewNode.value = value
    prevNode.next = NewNode
    nextNode.prev = NewNode
    NewNode.next = nextNode
    NewNode.prev = prevNode
    result_itr.node = NewNode
  end
  return result_itr
end

function List:InsertBefore(itr, value)
  if nil == itr or nil == itr.node or itr.owner ~= self then
    return
  end
  local result_itr = List_Iterator:New(self)
  if itr.node == self.first then
    self:PushFront(value)
    result_itr.node = self.first
  else
    local prevNode = itr.node.prev
    local nextNode = itr.node
    local NewNode = List_Node:New()
    NewNode.value = value
    prevNode.next = NewNode
    nextNode.prev = NewNode
    NewNode.next = nextNode
    NewNode.prev = prevNode
    result_itr.node = NewNode
  end
  return result_itr
end

function iList(l)
  local itr_first = List_Iterator:New(l)
  itr_first.node = List_Node:New()
  itr_first.node.next = l.first
  local ilist_it = function(itr)
    itr:Next()
    local v = itr:Value()
    if v ~= nil then
      return v, itr
    else
      return nil
    end
  end
  return ilist_it, itr_first
end

function riList(l)
  local itr_last = List_Iterator:New(l)
  itr_last.node = List_Node:New()
  itr_last.node.prev = l.last
  local rilist_it = function(itr)
    itr:Prev()
    local v = itr:Value()
    if v ~= nil then
      return v, itr
    else
      return nil
    end
  end
  return rilist_it, itr_last
end

function List:Print()
  for v in riList(self) do
    print(tostring(v))
  end
end

function List:Size()
  local count = 0
  for v in iList(self) do
    count = count + 1
  end
  return count
end

function List:Clone()
  local NewList = List:New()
  for v in iList(self) do
    NewList:PushBack(v)
  end
  return NewList
end

function List:Clear()
	self.first = nil
	self.last = nil
end


list = {}
list.__index = list

function list:new()
  local t = {length = 0, _prev = 0, _next = 0}
  t._prev = t
  t._next = t
  return setmetatable(t, list)
end

function list:clear()
  self._next = self
  self._prev = self
  self.length = 0
end

function list:push(value)
  --assert(value)
  local node = {value = value, _prev = 0, _next = 0, removed = false}

  self._prev._next = node
  node._next = self
  node._prev = self._prev
  self._prev = node

  self.length = self.length + 1
  return node
end

function list:pushnode(node)
  if not node.removed then return end

  self._prev._next = node
  node._next = self
  node._prev = self._prev
  self._prev = node
  node.removed = false
  self.length = self.length + 1
end

function list:pop()
  local _prev = self._prev
  self:remove(_prev)
  return _prev.value
end

function list:unshift(v)
  local node = {value = v, _prev = 0, _next = 0, removed = false}

  self._next._prev = node
  node._prev = self
  node._next = self._next
  self._next = node

  self.length = self.length + 1
  return node
end

function list:shift()
  local _next = self._next
  self:remove(_next)
  return _next.value
end

function list:remove(iter)
  if iter.removed then return end

  local _prev = iter._prev
  local _next = iter._next
  _next._prev = _prev
  _prev._next = _next
  
  self.length = math.max(0, self.length - 1)
  iter.removed = true
end

function list:find(v, iter)
  iter = iter or self

  repeat
    if v == iter.value then
      return iter
    else
      iter = iter._next
    end   
  until iter == self

  return nil
end

function list:findlast(v, iter)
  iter = iter or self

  repeat
    if v == iter.value then
      return iter
    end

    iter = iter._prev
  until iter == self

  return nil
end

function list:next(iter)
  local _next = iter._next
  if _next ~= self then
    return _next, _next.value
  end

  return nil
end

function list:prev(iter)
  local _prev = iter._prev
  if _prev ~= self then
    return _prev, _prev.value
  end

  return nil
end

function list:erase(v)
  local iter = self:find(v)

  if iter then
    self:remove(iter)   
  end
end

function list:insert(v, iter) 
  if not iter then
    return self:push(v)
  end

  local node = {value = v, _next = 0, _prev = 0, removed = false}

  if iter._next then
    iter._next._prev = node
    node._next = iter._next
  else
    self.last = node
  end

  node._prev = iter
  iter._next = node
  self.length = self.length + 1
  return node
end

function list:head()
  return self._next.value
end

function list:tail()
  return self._prev.value
end

function list:clone()
  local t = list:new()

  for i, v in list.next, self, self do
    t:push(v)
  end

  return t
end

ilist = function(_list) return list.next, _list, _list end
rilist = function(_list) return list.prev, _list, _list end

setmetatable(list, {__call = list.new})
return list