using System.Collections;
using System.Collections.Generic;
using RFramework;
using UnityEngine;

public class AssetBundleModule : BaseModule
{
    private static AssetBundleModule m_instance;
    public static AssetBundleModule Instance => m_instance ?? (m_instance = new AssetBundleModule());

    public delegate void LoadCompleteCallback(AssetObjectLoader obj);
    
    public override void OnStart()
    {
        
    }

    public override void OnUpdate()
    {
        
    }


    public override void OnFinishStart()
    {
        
    }

    public override void OnDestroy()
    {
        
    }
}
