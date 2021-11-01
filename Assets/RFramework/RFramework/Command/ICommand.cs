using UnityEngine;

namespace RFramework
{
    public abstract class ICommand
    {
        public abstract void Execute();
    }

    public abstract class ObjCommand : ICommand
    {
        protected abstract void InitObj(GameObject obj);
    }
}
