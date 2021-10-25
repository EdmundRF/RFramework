using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AssetBundleLoader
{
    private string m_Path;
    private List<AssetBundleObject> m_Assets;
    private AssetBundle m_AssetBundle;
    //private AssetBundleCreateRequest m_AssetBundleRequest;
    private AssetBundleRequest m_AssetRequest;

    private Action m_CallBack;

    public AssetBundleLoader(string path)
    {
        m_Path = path;
        m_Assets = new List<AssetBundleObject>();
    }

    public void Load()
    {
        m_AssetBundle = AssetBundle.LoadFromFile(m_Path);
    }

    public IEnumerator LoadAsyn(Action callBack)
    {
        //m_CallBack = callBack;
        if (m_AssetBundle == null)
        {
            var assetBundleRequest = AssetBundle.LoadFromFileAsync(m_Path);
            yield return assetBundleRequest;
            m_AssetBundle = assetBundleRequest.assetBundle;
            if(m_AssetBundle == null)
                Debug.LogError("");
        }
        
        
    }
}
