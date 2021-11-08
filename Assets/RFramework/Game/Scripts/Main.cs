using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using RFramework;

public class Main : MonoBehaviour
{
    private Main m_instance;
    public Main Instance => m_instance;

    private ModuleManager m_moduleManager;

    private void Awake()
    {
        m_instance = this;
    }

    void MainAwake()
    {
        m_moduleManager = new ModuleManager();
        
        /// 注册Module ///
        m_moduleManager.AddModule(LuaModule.Instance);
        //m_moduleManager.AddModule(...);
        
    }

    private void Start()
    {
        
    }

    private void Update()
    {
        m_moduleManager.UpdateModules();
    }

    private void LateUpdate()
    {
        m_moduleManager.LateUpdateModules();
    }

    private void OnDestroy()
    {
        m_moduleManager.DestroyModules();
    }
}
