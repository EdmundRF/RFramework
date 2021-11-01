using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

public class PathUtil
{
    private static readonly string PATH_DATA = Application.dataPath;
    private static readonly string PATH_PERSISTENT_DATA = Application.persistentDataPath;
    private static readonly string PATH_ASSET_PHONE = PATH_PERSISTENT_DATA + "/data";
    private static readonly string PATH_ASSET_EDITOR = PATH_DATA + "/自定义路径";

    private static readonly string PATH_AB = "自定义路径";
    public static readonly string END_AB = ".自定义后缀";
    private static readonly string PATH_LUA = "自定义路径";
    public static readonly string END_LUA = ".自定义后缀";

    public static string GetAssetBundlePath(string name)
    {
        return TryGetPath(Path.Combine(PATH_AB, name));
    }
    
    public static string GetLuaPath(string name)
    {
        return TryGetPath(Path.Combine(PATH_LUA, name + END_LUA));
    }

    public static string TryGetPath(string path)
    {
#if UNITY_EDITOR
        string p = Path.Combine(PATH_ASSET_EDITOR, path);
        if (File.Exists(p))
        {
            return p;
        }
        return null;
#else
        string p = Path.Combine(PATH_ASSET_PHONE, path);
        if (File.Exists(p))
        {
            return p;
        }
        return null;
#endif
    }
    
    
}
