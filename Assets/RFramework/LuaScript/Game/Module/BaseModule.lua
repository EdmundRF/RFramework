BaseModule = BaseClass()

function BaseModule:OnStart()
	self.IsComplete = true -- 标记初始化完成
end

function BaseModule:OnFinishStart() end
function BaseModule:OnDestroy() end

BaseModule.OnUpdate = nil
BaseModule.OnLateUpdate = nil