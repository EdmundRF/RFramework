using System.Collections;
using System.Collections.Generic;
using RFramework;
using UnityEngine;

public class ModuleManager
{
    private List<BaseModule> m_allModule;                         // 所有Module
    private List<BaseModule> m_updateModule;                      // 需要Update的Module
    private List<LateUpdateModuleInterface> m_lateUpdateModule;   // 需要LateUpdate的Module
    private Queue<BaseModule> m_startQueue;                       // 初始化队列
    private BaseModule m_starting;                                // 当前正在初始化的Module

    public ModuleManager()
    {
        m_allModule = new List<BaseModule>();
        m_updateModule = new List<BaseModule>();
        m_lateUpdateModule = new List<LateUpdateModuleInterface>();
        m_startQueue = new Queue<BaseModule>();
    }

    public void AddModule(BaseModule module)
    {
        if (m_allModule.Contains(module)) return;
        m_allModule.Add(module);
        m_startQueue.Enqueue(module);
    }

    /// <summary>
    /// 检查当前starting是否已完成，根据IsComplete判断
    /// </summary>
    public void CheckStartComplete()
    {
        if (m_starting == null && m_startQueue.Count == 0) return;

        if (m_starting == null)
        {
            m_starting = m_startQueue.Dequeue();
            m_starting.OnStart();
        }
        if (m_starting.IsComplete)
        {
            // 初始化完成
            m_starting.OnFinishStart();
            if (m_starting.IsUpdate)
            {
                m_updateModule.Add(m_starting);
            }
            var lateUpdate = m_starting as LateUpdateModuleInterface;
            if (lateUpdate != null)
            {
                m_lateUpdateModule.Add(lateUpdate);
            }
            // 下一个
            if (m_startQueue.Count > 0)
            {
                m_starting = m_startQueue.Dequeue(); 
                m_starting.OnStart();
            }
            else
            {
                m_starting = null;
            }
        }
        else if(m_starting.IsUpdate)
        {
            m_starting.OnUpdate();
        }
    }

    /// <summary>
    /// 初始化以及OnUpdate
    /// </summary>
    public void UpdateModule()
    {
        CheckStartComplete();
        foreach (var module in m_updateModule)
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
