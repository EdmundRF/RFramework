local ModuleManager_Class = BaseClass()

function ModuleManager_Class:ctor()
	self.m_moduleList = {}
	self.m_lateUpdateModule = {}
	self.m_startQueue = {}
	self.m_starting = nil
end

function ModuleManager_Class:AddModule(module)
	table.insert(self.m_startQueue, module)
end

function ModuleManager_Class:CheckStartComplete()
	if self.m_starting == nil and #self.m_startQueue == 0 then
		return
	end

	if self.m_starting == nil then
		self.m_starting = table.remove(self.m_startQueue, 1)
		self.m_starting:OnStart()
	end
end

ModuleManager = ModuleManager_Class.New()