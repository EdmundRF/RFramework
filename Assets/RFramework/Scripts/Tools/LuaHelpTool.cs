using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

public class LuaHelpTool
{
    /// <summary>
    /// 新建一个空白Lua文件
    /// </summary>
    [MenuItem("Assets/Lua/NewLua")]
    static void CreateLuaFile()
    {
        var select = Selection.activeObject;
        if (select == null) return;
        var path = AssetDatabase.GetAssetPath(select);
        path = path.Replace("Assets", Application.dataPath);
        var filePath = path + "/NewLua.lua";
        int index = 2;
        while (File.Exists(filePath))
        {
            filePath = path + "/NewLua" + index++ + ".lua";
        }
        var stream = File.Create(filePath);
        stream.Close();
        AssetDatabase.Refresh();
    }
}
