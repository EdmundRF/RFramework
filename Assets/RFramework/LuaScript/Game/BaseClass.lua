local _class = {}

function BaseClass(super)
	local class_type = {}
	class_type.ctor = false -- 构造函数
	class_type.super = super --  父类

	class_type.New = function(...)
		local obj = {}
		do
			local create -- 创建函数 用于实现嵌套调用，目的是调用父类的构造函数
			create = function(c, ...)
				-- 如果存在父类，则先去递归调用父类的构造函数
				if c.super then
					create(c,super, ...)
				end

				-- 调用自身的构造函数
				if c.ctor then
					c.ctor(obj, ...)
				end
			end
			create(class_type, ...)
		end
		setmetatable(obj, { __index = _class[class_type] }) -- 继承本类，相当于实例化一个对象obj
		return obj -- new方法返回obj对象
	end

	local vtbl = {} -- 函数表/容器
	_class[class_type] = vtbl

	--[[
	新增字段的时候，存到vtbl中
	--]]
	setmetatable(class_type, {__newindex = 
		function(t, k, v)
			vtbl[k] = v
		end
	})

	--[[
	如果存在父类，则绑定父类的函数表，找不到的字段 从父类里找，即继承
	--]]
	if super then
		setmetatable(vtbl, {__index = 
			function(t, k)
				local ret = _class[super][k] -- 查找父类的函数表
				vtbl[k] = ret
				return ret
			end
		})
	end

	return class_type
end