using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface AsyncLoader
{
    IEnumerator LoadAsync();

    bool IsComplete();
}
