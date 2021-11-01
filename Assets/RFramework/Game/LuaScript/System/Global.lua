-- require "System.Wrap"
-- luanet.load_assembly("UnityEngine")

System                  = CS.System
object					= CS.System.Object
Type					= CS.System.Type
UnityEngine             = CS.UnityEngine
Object      		    = CS.UnityEngine.Object
GameObject 				= CS.UnityEngine.GameObject
Transform 				= CS.UnityEngine.Transform
MonoBehaviour		 	= CS.UnityEngine.MonoBehaviour
Component				= CS.UnityEngine.Component
Application				= CS.UnityEngine.Application
Camera					= CS.UnityEngine.Camera
Material 				= CS.UnityEngine.Material
Renderer 				= CS.UnityEngine.Renderer
AssetBundle				= CS.UnityEngine.AssetBundle
AsyncOperation			= CS.UnityEngine.AsyncOperation
WWW						= CS.UnityEngine.WWW
WWWForm                 = CS.UnityEngine.WWWForm
Screen                  = CS.UnityEngine.Screen
--RenderTextureFormat		= CS.UnityEngine.RenderTextureFormat
Texture					= CS.UnityEngine.Texture
Texture2D				= CS.UnityEngine.Texture2D
RenderTexture			= CS.UnityEngine.RenderTexture
SpriteRenderer			= CS.UnityEngine.SpriteRenderer
Animator 				= CS.UnityEngine.Animator
Animation 				= CS.UnityEngine.Animation

Rect                    = CS.UnityEngine.Rect
Collider2D 				= CS.UnityEngine.Collider2D
BoxCollider2D			= CS.UnityEngine.BoxCollider2D
Physics2D				= CS.UnityEngine.Physics2D
PolygonCollider2D		= CS.UnityEngine.PolygonCollider2D
PlayerPrefs				= CS.UnityEngine.PlayerPrefs

EventSystems			= CS.UnityEngine.EventSystems

Input					= CS.UnityEngine.Input
AudioClip				= CS.UnityEngine.AudioClip
AudioSource				= CS.UnityEngine.AudioSource
Physics					= CS.UnityEngine.Physics
ParticleEmitter			= CS.UnityEngine.ParticleEmitter
ParticleSystem 			= CS.UnityEngine.ParticleSystem
ParticleSystemRenderer 	= CS.UnityEngine.ParticleSystemRenderer
Debugger                = CS.UnityEngine.Debug
SceneManager            = CS.UnityEngine.SceneManagement.SceneManager
LoadSceneMode           = CS.UnityEngine.SceneManagement.LoadSceneMode

-- Custom
EventSystem             = CS.EventSystem
Main                    = CS.Main

Devoloper =
{
    all = 0,
    lcz = 1,
    ljm = 2,
    ldl = 3,
    sly = 4,
    cjy = 5,
}

Screen =
{
    width = CS.UnityEngine.Screen.width,
    height = CS.UnityEngine.Screen.height,
}

IsOpenLog = true

-- xlua.hotfix(CS.LuaModule, "TestHotfix"  , function (self)
--     print("lua---------------------------------hotfix TestHotfix")
-- end)

function getDevlopID( )
    return  EventSystemLuaManager.Fire(100000, nil, {})
end

--[[必须添加开发者ID的信息 这样可以过滤打印。]]
function logPrint(...)
    -- body
    local arg = {...}
    if arg[#arg] == getDevlopID() then
        Debugger.Log(traceback(str))
    end
end

function print(...)
    if not IsOpenLog then
        return
    end

	local arg = {...}
	local t = {}
	for i,k in ipairs(arg) do
        if type(k) == 'number' then
            local a, b = math.modf(k)
            if math.abs(b) <= 0.000001 then
                table.insert(t, string.format('%d', a))
            else
                table.insert(t, tostring(k))
            end
        else
            table.insert(t, tostring(k))
        end
    end

	local str = table.concat(t, " ")
    Debugger.Log(traceback(str))
end

function printf(format , ...)
	Debugger.Log(string.format(format, ...))
end

local oldPairs = pairs
function pairs(tbl)
    if tbl.Init ~= nil then
        return oldPairs(tbl.Init())
    end
    return oldPairs(tbl)
end

local oldiPairs = ipairs
function ipairs(tbl)
    if tbl.Init ~= nil then
        return oldiPairs(tbl.Init())
    end
    return oldiPairs(tbl)
end

require "System.Math"
Mathf           = require "System.Mathf"
require "System.Layer"
List            = require "System.List"
Time            = require "System.Time"
require "System.Event"
require "System.Timer"
require "System.StackAndQueue"
Object          = require "System.Object"

Vector3         = require "System.Vector3"
Vector2         = require "System.Vector2"
Quaternion      = require "System.Quaternion"
Vector4         = require "System.Vector4"
require "System.Raycast"
Color           = require "System.Color"
Touch           = require "System.Touch"
Ray             = require "System.Ray"
Plane           = require "System.Plane"
Bounds          = require "System.Bounds"

require "System.Coroutine"
JsonHelper = require("System.Json")


function traceback(msg)
	msg = debug.traceback(msg, 2)

	if ErrorHandler and ErrorHandler.Instance then
		ErrorHandler.Instance:AddError(msg)
	end

	return msg
end

function warning(msg)
    if not IsOpenLog then
        return
    end
    Debugger.LogWarning(msg)
end

function error(...)
    if not IsOpenLog then
        return
    end

    local arg = {...}
    local t = {}
    for i,k in ipairs(arg) do
        if type(k) == 'number' then
            local a, b = math.modf(k)
            if math.abs(b) <= 0.000001 then
                table.insert(t, string.format('%d', a))
            else
                table.insert(t, tostring(k))
            end
        else
            table.insert(t, tostring(k))
        end
    end

    local str ="<color=green>" .. table.concat(t, " ") .. "</color>"
    Debugger.LogError(traceback(str))
end

function LuaGC()
    local c = collectgarbage("count")
    if IsOpenLog then
        print("Begin gc: ", c)
    end
    collectgarbage("collect")
    c = collectgarbage("count")
    if IsOpenLog then
        print("End gc:", c)
    end
end

function RemoveTableItem(list, item, removeAll)
    local rmCount = 0

    for i = 1, #list do
        if list[i - rmCount] == item then
            table.remove(list, i - rmCount)

            if removeAll then
                rmCount = rmCount + 1
            else
                break
            end
        end
    end
end

function destroy(obj)
    if not IsNil(obj) then
	   GameObject.Destroy(obj)
    end
end

--unity 对象判断为空, 如果你有些对象是在c#删掉了，lua 不知道
--判断这种对象为空时可以用下面这个函数。
function IsNil(uobj)
	return uobj == nil or uobj:IsNull()
end

-- 将xlua的64位userdata转化为lua number
function XluaToNumber(xluaInt64)
    return tonumber(uint64.tostring(xluaInt64))
end

-- isnan
function isnan(number)
	return not (number == number)
end

function GetDir(path)
	return string.match(fullpath, ".*/")
end

function GetFileName(path)
	return string.match(fullpath, ".*/(.*)")
end

function table.merge(arr1, arr2)
    table.sort(arr1)
    table.sort(arr2)

    local i1 = 1
    local i2 = 1
    local result = {}
    while i1 <= #arr1 and i2 <= #arr2 do
        if arr1[i1] < arr2[i2] then
            table.insert(result, arr1[i1])
            i1 = i1 + 1
        elseif arr1[i1] > arr2[i2] then
            table.insert(result, arr2[i2])
            i2 = i2 + 1
        else
            table.insert(result, arr1[i1])
            i1 = i1 + 1
            i2 = i2 + 1
        end
    end

    if i1 > #arr1 then
        for i = i2, #arr2 do
            table.insert(result, arr2[i])
        end
    end

    if i2 > #arr2 then
        for i = i1, #arr1 do
            table.insert(result, arr1[i])
        end
    end

    return result
end

function table.contains(table, element)
  if table == nil then
        return false
  end

  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

--[Comment]
--获取指定值对应的下标
function table.getIdxWithValue(table, element)
  if table == nil then
        return nil
  end

  for idx, value in pairs(table) do
    if value == element then
      return idx
    end
  end

  return nil
end

function table.getCount(self)
    if not self then
        print("table.getCount-not self")
        return 0
    end
	local count = 0
	for k, v in pairs(self) do
		count = count + 1
	end
	return count
end

function table.clear(t)
    for k in pairs(t) do
        t[k] = nil
    end
end

table.nums = table.getCount

function string:split(sep)
  local sep, fields = sep or ",", {}
  local pattern = string.format("([^%s]+)", sep)
  self:gsub(pattern, function(c) table.insert(fields, c) end)
  return fields
end

-- 字符串分割
function string.split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    -- for each divider found
    for st,sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end

function string.trim(input)
    input = string.gsub(input, "^[ \t\n\r]+", "")
    return string.gsub(input, "[ \t\n\r]+$", "")
end

function string.startswith(str, substr)
    if str == nil or substr == nil then
        return nil, "the string or the sub-stirng parameter is nil"
    end
    if string.find(str, substr) ~= 1 then
        return false
    else
        return true
    end
end

    local function copyObj( object, lookup_table )
        if type( object ) ~= "table" or object.canNotClone then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end

        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs( object ) do
            new_table[copyObj( key, lookup_table )] = copyObj( value, lookup_table )
        end
        return setmetatable( new_table, getmetatable( object ) )
    end

--[[ 用于克隆一个lua对象
-- @param object 要克隆的值
-- @return objectCopy 返回值的副本
--]]
function clone( object )
    local lookup_table = {}
    return copyObj( object, lookup_table )
end

function shallowClone(object)
    local cloneObj = {}
    for key, value in pairs(object) do
        cloneObj[key] = value
    end
    return cloneObj
end

local function dump_value_(v)
    if type(v) == "string" then
        return "\"" .. v .. "\""
    elseif type(v) == 'number' then
        local a, b = math.modf(v)
        if math.abs(b) <= 0.00001 then
            return string.format('%d', a)
        else
            return tostring(v)
        end
    end

    return tostring(v)
end

-- 主要用于显示表格, 表格，标识,显示表格的深度，默认3级
function dump(value, desciption, nesting, show_meta)
    if not IsOpenLog then
        return
    end
    if type(nesting) ~= "number" then nesting = 3 end

    show_meta = show_meta or false
    local lookupTable = {}
    local result = {}

    local traceback = string.split(debug.traceback("", 2), "\n")
    if IsOpenLog then
        print("dump from: " .. string.trim(traceback[3]))
    end

    local function dump_(value, desciption, indent, nest, keylen)
        desciption = desciption or "<var>"
        local spc = ""
        if type(keylen) == "number" then
            spc = string.rep(" ", keylen - string.len(dump_value_(desciption)))
        end
        if type(value) ~= "table" then
            result[#result +1 ] = string.format("%s%s%s = %s", indent, dump_value_(desciption), spc, dump_value_(value))
        elseif lookupTable[tostring(value)] then
            result[#result +1 ] = string.format("%s%s%s = *REF*", indent, dump_value_(desciption), spc)
        else
            lookupTable[tostring(value)] = true
            if nest > nesting then
                result[#result +1 ] = string.format("%s%s = *MAX NESTING*", indent, dump_value_(desciption))
            else
                result[#result +1 ] = string.format("%s%s = {", indent, dump_value_(desciption))
                local indent2 = indent.."    "
                local keys = {}
                local keylen = 0
                local values = {}
                for k, v in pairs(value) do
                    keys[#keys + 1] = k
                    local vk = dump_value_(k)
                    local vkl = string.len(vk)

                    if vkl > keylen then keylen = vkl end
                    values[k] = v
                end
                table.sort(keys, function(a, b)
                    if type(a) == "number" and type(b) == "number" then
                        return a < b
                    else
                        return tostring(a) < tostring(b)
                    end
                end)
                for i, k in ipairs(keys) do
                    dump_(values[k], k, indent2, nest + 1, keylen)
                end
                result[#result +1] = string.format("%s}", indent)
            end
        end
    end
    dump_(value, desciption, "\n", 1)
    local outStr="";
    for i, line in ipairs(result) do
        outStr = outStr..line
    end
    Debugger.Log(outStr)
end




PrintTable = dump
DumpTable = dump

DebugTool = {}
DebugTool.PrintTable = dump

-- 绝对不能在别的线程中调用
local no_error_in_trycathc = true
local function TryCatchError(msg)
    no_error_in_trycathc = false
    error(msg)
end

function TryCatch(func)
    no_error_in_trycathc = true
    xpcall(func, TryCatchError)
    return no_error_in_trycathc
end

function GHandler(obj, method)
    return function(...)
        return method(obj, ...)
    end
end
