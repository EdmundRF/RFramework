require('Game.BaseClass')
require('MainDefine')

--ModuleManager:AddModule(...)

function UpdateMain()
	ModuleManager:UpdateModules()
end

function LateUpdateMain()
	ModuleManager:LateUpdateModules()
end

function DestroyMain()
	ModuleManager:DestroyModules()
end