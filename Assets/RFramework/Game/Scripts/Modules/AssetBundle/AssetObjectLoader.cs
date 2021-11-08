using System.Collections;
using System.Collections.Generic;
using RFramework;
using UnityEngine;

public class AssetObjectLoader : AsyncLoader
{
    public enum AssetObjectLoadState
    {
        UnLoad,
        Loading,
        Load,
        Failed,
    }

    private AssetObjectLoadState m_State;
    private string m_FullName;                     // 相对路径完整名称
    private string m_AssetName;                    // 资源名称
    private System.Type m_Type;                    // 资源类型
    private AssetBundleLoader m_BundleLoader;      // 所属BundleLoader

    private Object m_Asset;
    private List<GameObject> m_instObj;

    public AssetObjectLoader(string name, AssetBundleLoader loader)
    {
        m_FullName = name;
        
        var p = name.LastIndexOf(".");
        if (p != -1)
        {
            m_AssetName = name.Remove(p);
            var typeName = name.Remove(0, p + 1).ToLower();
            switch (typeName)
            {
                case "prefab":
                case "fbx":
                    m_Type = typeof(GameObject);
                    break;
                case "mat":
                case "material":
                    m_Type = typeof(Material);
                    break;
                case "png":
                case "tga":
                case "jpg":
                    m_Type = typeof(Texture2D);
                    break;
                case "unity":
                    m_Type = typeof(UnityEngine.SceneManagement.Scene);
                    break;
                case "controller":
                    m_Type = typeof(RuntimeAnimatorController);
                    break;
                case "lua":
                    m_Type = null;
                    break;
                case "txt":
                case "bytes":
                    m_Type = typeof(TextAsset);
                    break;
                default:
                    m_Type = null;
                    break;
            }
        }
        else
        {
            m_AssetName = name;
            m_Type = null;
        }
        m_BundleLoader = loader;

        m_State = AssetObjectLoadState.UnLoad;
    }

    public bool IsComplete()
    {
        return m_State != AssetObjectLoadState.Loading;
    }

    public IEnumerator LoadAsync()
    {
        if (m_State != AssetObjectLoadState.UnLoad) yield break;
        m_State = AssetObjectLoadState.Loading;
        var request = m_BundleLoader.Bundle.LoadAssetAsync(m_AssetName, m_Type);
        yield return request;

        if (m_State == AssetObjectLoadState.Loading)
        {
            m_Asset = request.asset;
            if (m_Asset != null)
            {
                m_State = AssetObjectLoadState.Load;
            }
            else
            {
                m_State = AssetObjectLoadState.Failed;
            }
        }
    }

    public void LoadSync()
    {
        if (m_State != AssetObjectLoadState.UnLoad) return;
        m_Asset = m_BundleLoader.Bundle.LoadAsset(m_AssetName, m_Type);

        if (m_Asset != null)
        {
            m_State = AssetObjectLoadState.Load;
        }
        else
        {
            m_State = AssetObjectLoadState.Failed;
        }
    }

    #region Instantiate实例化
    
    public GameObject Instantiate()
    {
        if (m_State != AssetObjectLoadState.Load || m_Type != typeof(GameObject))
        {
            LogManager.LogError("== Instantiate Error == " + m_AssetName);
        }
        var obj = GameObject.Instantiate(m_Asset as GameObject);
        m_instObj.Add(obj);
        return obj;
    }
    
    public GameObject Instantiate(Transform parent)
    {
        if (m_State != AssetObjectLoadState.Load || m_Type != typeof(GameObject))
        {
            LogManager.LogError("== Instantiate Error == " + m_AssetName);
        }
        var obj = GameObject.Instantiate(m_Asset as GameObject, parent);
        m_instObj.Add(obj);
        return obj;
    }
    
    public GameObject Instantiate(Vector3 pos, Quaternion qua)
    {
        if (m_State != AssetObjectLoadState.Load || m_Type != typeof(GameObject))
        {
            LogManager.LogError("== Instantiate Error == " + m_AssetName);
        }
        var obj = GameObject.Instantiate(m_Asset as GameObject, pos, qua);
        m_instObj.Add(obj);
        return obj;
    }
    
    public GameObject Instantiate(Vector3 pos, Quaternion qua, Transform parent)
    {
        if (m_State != AssetObjectLoadState.Load || m_Type != typeof(GameObject))
        {
            LogManager.LogError("== Instantiate Error == " + m_AssetName);
        }
        var obj = GameObject.Instantiate(m_Asset as GameObject, pos, qua, parent);
        m_instObj.Add(obj);
        return obj;
    }
    
    #endregion

    public bool CheckNoUsed()
    {
        m_instObj.ClearNull();
        return m_instObj.Count == 0;
    }
}
