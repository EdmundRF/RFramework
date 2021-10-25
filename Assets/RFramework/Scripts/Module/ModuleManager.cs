using System.Collections;
using System.Collections.Generic;
using RFramework;
using UnityEngine;

public class ModuleManager
{
    private List<BaseModule> m_ModuleList;
    private Queue<BaseModule> m_StartQueue;

    public ModuleManager()
    {
        m_ModuleList = new List<BaseModule>();
        m_StartQueue = new Queue<BaseModule>();
    }

    public void AddModule(BaseModule module)
    {
        m_ModuleList.Add(module);
        m_StartQueue.Enqueue(module);
    }

    public void StartModule()
    {
        while (m_StartQueue.Count > 0)
        {
            var module = m_StartQueue.Dequeue();
            module.OnStart();
        }
    }

    public void UpdateModule()
    {
        foreach (var module in m_ModuleList)
        {
            module.OnUpdate();
        }
    }
    
    public void LateUpdateModule()
    {
        foreach (var module in m_ModuleList)
        {
            module.OnLateUpdate();
        }
    }
    
    public void DestroyModule()
    {
        foreach (var module in m_ModuleList)
        {
            module.OnDestroy();
        }
    }
}
