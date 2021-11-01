-------------- 基类 --------------
SampleClass = BaseClass()

function SampleClass:ctor(x, ...) -- 构造函数
	self.x = x
end

function SampleClass:PrintX()
	print(self.x)
end
----------------------------------------------------------

-------------- 子类 --------------
SampleSon = BaseClass(SampleClass) -- 传入父类

function SampleSon:ctor(...) -- 构造函数
	-- body
end

function SampleSon:Hello()
	print('hello')
end
---------------------------------------------------------

-------------- 实例化 --------------
a = SampleSon.New(1)
a:PrintX()
a:Hello()
----------------------------------------------------------