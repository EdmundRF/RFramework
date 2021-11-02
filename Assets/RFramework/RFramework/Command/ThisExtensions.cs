using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace RFramework
{
    public static class ThisExtensions
    {
        /// <summary>
        /// 移除所有null元素
        /// </summary>
        /// <param name="ls"></param>
        public static void ClearNull(this List<GameObject> ls)
        {
            List<GameObject> del = new List<GameObject>();
            for (int i = 0; i < ls.Count; i++)
            {
                if (ls[i] == null)
                {
                    del.Add(ls[i]);
                }
            }

            foreach (var i in del)
            {
                ls.Remove(i);
            }
        }
    }
}
