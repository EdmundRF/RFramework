using System.Collections;
using System.Collections.Generic;
using RFramework;
using UnityEngine;

public class ModuleManager
{
    private List<BaseModule> m_moduleList;                         // 正在运行的所有Module
    private List<LateUpdateModuleInterface> m_lateUpdateModule;    // 需要LateUpdate的Module
    private Queue<BaseModule> m_startQueue;                        // 初始化队列

    public ModuleManager()
    {
        m_moduleList = new List<BaseModule>();
        m_lateUpdateModule = new List<LateUpdateModuleInterface>();
        m_startQueue = new Queue<BaseModule>();
    }

    public void AddModule(BaseModule module)
    {
        m_startQueue.Enqueue(module);
    }

    /// <summary>
    /// OnStart
    /// </summary>
    public void StartModule()
    {
        while (m_startQueue.Count > 0)
        {
            var module = m_startQueue.Dequeue();
            module.OnStart();
            module.OnFinishStart();
            m_moduleList.Add(module); // 初始化完成后才放入列表

            var lateUpdate = module as LateUpdateModuleInterface;
            if (lateUpdate != null)
            {
                m_lateUpdateModule.Add(lateUpdate);
            }
        }
    }

    /// <summary>
    /// OnUpdate
    /// </summary>
    public void UpdateModule()
    {
        foreach (var module in m_moduleList)
        {
            module.OnUpdate();
        }
    }

    /// <summary>
    /// OnLateUpdate
    /// </summary>
    public void LateUpdateModule()
    {
        foreach (var module in m_lateUpdateModule)
        {
            module.OnLateUpdate();
        }
    }

    /// <summary>
    /// OnDestroy
    /// </summary>
    public void DestroyModule()
    {
        foreach (var module in m_moduleList)
        {
            module.OnDestroy();
        }
    }
}
