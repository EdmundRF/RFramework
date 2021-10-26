using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AssetBundleLoader : AsyncLoader
{
    public enum AssetBundleLoadState
    {
        UnLoad,
        Loading,
        Load,
        Failed,
        Destroyed
    }

    private AssetBundleLoadState m_State;
    private string m_Path;
    private Dictionary<string, AssetObjectLoader> m_AssetsLoaders;
    private AssetBundle m_AssetBundle;
    public AssetBundle Bundle => m_AssetBundle;
    private AssetBundleCreateRequest m_BundleRequest;
    private AssetBundleRequest m_AssetRequest;

    private Action m_CallBack;

    public AssetBundleLoader(string bundleName)
    {
        m_Path = PathUtil.GetAssetBundlePath(bundleName);
        m_AssetsLoaders = new Dictionary<string, AssetObjectLoader>();
        m_State = AssetBundleLoadState.UnLoad;
    }

    public bool IsComplete()
    {
        return m_State != AssetBundleLoadState.Loading;
    }

    public void LoadSync()
    {
        if (m_AssetBundle == null || m_State != AssetBundleLoadState.Load)
        {
            m_AssetBundle = AssetBundle.LoadFromFile(m_Path);
            if (m_AssetBundle != null)
            {
                m_State = AssetBundleLoadState.Load;
            }
            else
            {
                m_State = AssetBundleLoadState.Failed;
                Debug.LogError("<color=yellow>AssetBundleLoader</color> LoadSync Failed : " + m_Path);
            }
        }
    }

    public IEnumerator LoadAsync()
    {
        if (m_AssetBundle == null && m_State == AssetBundleLoadState.UnLoad)
        {
            m_State = AssetBundleLoadState.Loading;
            var bundleRequest = AssetBundle.LoadFromFileAsync(m_Path);
            yield return bundleRequest;

            if (m_State == AssetBundleLoadState.Loading)
            {
                m_AssetBundle = bundleRequest.assetBundle;
                if (m_AssetBundle != null)
                {
                    m_State = AssetBundleLoadState.Load;
                }
                else
                {
                    m_State = AssetBundleLoadState.Failed;
                    Debug.LogError("<color=yellow>AssetBundleLoader</color> LoadAsync Failed : " + m_Path);
                }
            }
        }
    }
    
    public void LoadAssetAsync(string name, AssetBundleModule.LoadCompleteCallback callback)
    {
        AssetObjectLoader loader;
        if (m_AssetsLoaders.ContainsKey(name))
        {
            loader = m_AssetsLoaders[name];
        }
        else
        {
            loader = new AssetObjectLoader(name, this);
            m_AssetsLoaders.Add(name, loader);
        }
    }

    public void LoadAwitAsset()
    {
        
    }
}
