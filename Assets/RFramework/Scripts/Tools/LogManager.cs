using System.Collections;
using System.Collections.Generic;
using System.Text;
using Unity.UNetWeaver;
using UnityEngine;

public class LogManager
{
    public static bool IsOpenLog = true;
    
    public static void Log(object message)
    {
        if (!IsOpenLog) return;
        Debug.Log(message);
    }
    
    public static void Logs(params object[] messages)
    {
        if (!IsOpenLog) return;
        if (messages == null || messages.Length == 0)
        {
            Debug.Log("");
        }
        else
        {
            StringBuilder log = new StringBuilder();
            foreach (var msg in messages)
            {
                log.Append(msg);
                log.Append(" ; ");
            }
            Debug.Log(log.ToString());
        }
    }
    
    public static void LogWarning(object message)
    {
        if (!IsOpenLog) return;
        Debug.LogWarning(message);
    }
    
    public static void LogWarnings(params object[] messages)
    {
        if (!IsOpenLog) return;
        if (messages == null || messages.Length == 0)
        {
            Debug.LogWarning("");
        }
        else
        {
            StringBuilder log = new StringBuilder();
            foreach (var msg in messages)
            {
                log.Append(msg);
                log.Append(" ; ");
            }
            Debug.LogWarning(log.ToString());
        }
    }
    
    public static void LogError(object message)
    {
        if (!IsOpenLog) return;
        Debug.LogError(message);
    }
    
    public static void LogErrors(params object[] messages)
    {
        if (!IsOpenLog) return;
        if (messages == null || messages.Length == 0)
        {
            Debug.LogError("");
        }
        else
        {
            StringBuilder log = new StringBuilder();
            foreach (var msg in messages)
            {
                log.Append(msg);
                log.Append(" ; ");
            }
            Debug.LogError(log.ToString());
        }
    }
}
