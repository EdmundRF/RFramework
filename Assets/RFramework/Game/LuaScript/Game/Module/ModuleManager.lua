-- 模组管理器，代码思路参考ModuleManaget.cs 

local ModuleManager_Class = BaseClass()

function ModuleManager_Class:ctor()
	self.m_allModules = {}
	self.m_updateModules = {}
	self.m_lateUpdateModules = {}
	self.m_startQueue = {}
	self.m_starting = nil
end

function ModuleManager_Class:AddModule(module)
	if module == nil then return end
	table.insert(self.m_startQueue, module)
	table.insert(self.m_allModules, module)
end

function ModuleManager_Class:CheckStartComplete()
	if self.m_starting == nil and #self.m_startQueue == 0 then
		return
	end

	if self.m_starting == nil then
		self.m_starting = table.remove(self.m_startQueue, 1)
		self.m_starting:OnStart()
	end
	if self.m_starting.IsComplete then
		self.m_starting:OnFinishStart()
		if self.m_starting.IsUpdate then
			table.insert(self.m_updateModules, self.m_starting)
		end
		if self.m_starting.OnLateUpdate then
			table.insert(self.m_lateUpdateModules, self.m_starting)
		end

		if #self.m_startQueue > 0 then
			self.m_starting = table.remove(self.m_startQueue, 1)
			self.m_starting:OnStart()
		else
			self.m_starting = nil
		end
	elseif self.m_starting.OnUpdate then
		self.m_starting:OnUpdate()
	end
end

function ModuleManager_Class:UpdateModules()
	self:CheckStartComplete()
	for _, v in self.m_updateModules do
		v:OnUpdate()
	end
end

function ModuleManager_Class:LateUpdateModules()
	for _, v in self.m_lateUpdateModules do
		v:OnLateUpdate()
	end
end

function ModuleManager_Class:DestroyModules()
	for _, v in self.m_allModules do
		v:OnDestroy()
	end
end

ModuleManager = ModuleManager_Class.New()