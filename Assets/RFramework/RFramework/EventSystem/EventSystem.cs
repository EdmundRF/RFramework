using System.Collections.Generic;

namespace RFramework
{
    public class EventSystem
    {
        public delegate object EventCallBack(params object[] ps);

        private static EventSystem m_instance;

        public static EventSystem Instance
        {
            get
            {
                if (m_instance == null)
                    m_instance = new EventSystem();
                return m_instance;
            }
        }

        private Dictionary<int, List<EventCallBack>> m_eventDic = new Dictionary<int, List<EventCallBack>>();

        /// <summary>
        /// 发送事件
        /// </summary>
        /// <param name="eventID">事件ID</param>
        /// <param name="ps">参数</param>
        /// <returns></returns>
        public object Fire(int eventID, params object[] ps)
        {
            object result = null;
            List<EventCallBack> list;
            if (m_eventDic.TryGetValue(eventID, out list))
            {
                foreach (var callback in list)
                {
                    result = callback(ps);
                }
            }

            return result;
        }

        /// <summary>
        /// 绑定事件
        /// </summary>
        /// <param name="eventID">事件ID</param>
        /// <param name="callback">事件回调</param>
        public void Bind(int eventID, EventCallBack callback)
        {
            List<EventCallBack> list;
            if (!m_eventDic.TryGetValue(eventID, out list))
            {
                list = new List<EventCallBack>();
                m_eventDic[eventID] = list;
            }

            if (!list.Contains(callback))
                list.Add(callback);
        }

        /// <summary>
        /// 解绑事件
        /// </summary>
        /// <param name="eventID">事件ID</param>
        /// <param name="callBack">事件回调</param>
        public void UnBind(int eventID, EventCallBack callBack)
        {
            List<EventCallBack> list;
            if (m_eventDic.TryGetValue(eventID, out list))
            {
                list.Remove(callBack);
                if (list.Count == 0)
                    m_eventDic.Remove(eventID);
            }
        }
    }
}
