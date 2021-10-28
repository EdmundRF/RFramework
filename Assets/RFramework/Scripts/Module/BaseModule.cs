using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace RFramework
{
    public abstract class BaseModule
    {
        public bool IsComplete;         // 是否已初始化完成
        protected bool m_isUpdate;      // 是否开启Update
        public bool IsUpdate => m_isUpdate;
        
        public abstract void OnStart();
        public abstract void OnUpdate();
        public abstract void OnFinishStart();
        public abstract void OnDestroy();
    }
    
    public interface LateUpdateModuleInterface
    {
        void OnLateUpdate();
    }
}
