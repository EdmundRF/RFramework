using System.Collections;
using System.Collections.Generic;
using RFramework;
using UnityEngine;

namespace RFramework
{
    /// <summary>
    /// 模组管理器，负责所有模组的初始化、Update、销毁
    /// </summary>
    public class ModuleManager
    {
        private List<BaseModule> m_allModules; // 所有Module
        private List<BaseModule> m_updateModules; // 需要Update的Module
        private List<LateUpdateModuleInterface> m_lateUpdateModules; // 需要LateUpdate的Module
        private Queue<BaseModule> m_startQueue; // 初始化队列
        private BaseModule m_starting; // 当前正在初始化的Module

        public ModuleManager()
        {
            m_allModules = new List<BaseModule>();
            m_updateModules = new List<BaseModule>();
            m_lateUpdateModules = new List<LateUpdateModuleInterface>();
            m_startQueue = new Queue<BaseModule>();
        }

        public void AddModule(BaseModule module)
        {
            if (m_allModules.Contains(module)) return;
            m_allModules.Add(module);
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
                    m_updateModules.Add(m_starting);
                }

                var lateUpdate = m_starting as LateUpdateModuleInterface;
                if (lateUpdate != null)
                {
                    m_lateUpdateModules.Add(lateUpdate);
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
            else // if(m_starting.IsUpdate)
            {
                m_starting.OnUpdate();
            }
        }

        /// <summary>
        /// 初始化以及OnUpdate
        /// </summary>
        public void UpdateModules()
        {
            CheckStartComplete();
            foreach (var module in m_updateModules)
            {
                module.OnUpdate();
            }
        }

        /// <summary>
        /// OnLateUpdate
        /// </summary>
        public void LateUpdateModules()
        {
            foreach (var module in m_lateUpdateModules)
            {
                module.OnLateUpdate();
            }
        }

        /// <summary>
        /// OnDestroy
        /// </summary>
        public void DestroyModules()
        {
            foreach (var module in m_allModules)
            {
                module.OnDestroy();
            }
        }
    }
}
