using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Main : MonoBehaviour
{
    private Main m_instance;
    public Main Instance => m_instance;

    private ModuleManager m_moduleManager;

    private void Awake()
    {
        
    }

    void MainAwake()
    {
        m_moduleManager = new ModuleManager();
        
        /// 注册Module ///
        m_moduleManager.AddModule(LuaModule.Instance);
        
        //////
    }

    private void Start()
    {
        m_moduleManager.StartModule();
    }

    private void Update()
    {
        m_moduleManager.UpdateModule();
    }

    private void LateUpdate()
    {
        m_moduleManager.LateUpdateModule();
    }
}
