using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace RFramework
{
    public abstract class BaseModule
    {
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
