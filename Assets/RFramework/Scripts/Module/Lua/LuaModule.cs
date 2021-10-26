using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using RFramework;
using UnityEngine;
using XLua;

[CSharpCallLua]
public delegate int CSharpCallLuaFun();

public class LuaModule : BaseModule, LateUpdateModuleInterface
{
    private static LuaModule m_instance;
    public static LuaModule Instance
    {
        get
        {
            if (m_instance == null)
            {
                m_instance = new LuaModule();
            }
            return m_instance;
        }
    }

    protected CSharpCallLuaFun m_updateFun;
    protected CSharpCallLuaFun m_lateUpdateFun;
    protected CSharpCallLuaFun m_destroyFun;

    public LuaEnv m_luaEnv;
    
    public override void OnStart()
    {
        m_luaEnv = new LuaEnv();
        m_luaEnv.AddLoader(LuaLoader); // 自定义Lua加载路径
        
        /// 加载全局变量 ///
        m_luaEnv.DoString("require('System.Global')");
        m_luaEnv.DoString("require('Game.Main')");
        
        //////
        
        /// 绑定Lua那边的Update LateUpdate Destroy
        m_luaEnv.Global.Get("UpdateMain", out m_updateFun);
        m_luaEnv.Global.Get("LateUpdateMain", out m_lateUpdateFun);
        m_luaEnv.Global.Get("DestroyMain", out m_destroyFun);
        
    }

    public override void OnUpdate()
    {
        if (m_updateFun != null)
            m_updateFun();
    }

    public void OnLateUpdate()
    {
        if (m_lateUpdateFun != null)
            m_lateUpdateFun();
    }

    public override void OnFinishStart()
    {
        
    }

    public override void OnDestroy()
    {
        if (m_destroyFun != null)
            m_destroyFun();
        if(m_luaEnv != null)
            m_luaEnv.Dispose();
        
        m_updateFun = null;
        m_lateUpdateFun = null;
        m_destroyFun = null;
        m_luaEnv = null;
    }

    public byte[] LuaLoader(ref string path)
    {
        byte[] luaBytes = null;
        string luaPath = PathUtil.GetLuaPath(path);

        try
        {
            if (File.Exists(luaPath))
            {
                luaBytes = Convert.FromBase64String(File.ReadAllText(luaPath, Encoding.UTF8));
                return luaBytes;
            }
        }
        catch (Exception e)
        {
            LogManager.LogErrors(path, luaPath, e);
        }

        return null;
    }
}
