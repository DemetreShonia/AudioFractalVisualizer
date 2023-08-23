using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class UIBoy : MonoBehaviour
{
    [SerializeField] Renderer _shaderRenderer;

    [SerializeField] Slider _iterSlider;
    [SerializeField] Slider _rotSlider;
    [SerializeField] Slider _typeSlider;
    void Start()
    {
        // reset default values!
        OnIterValueChanged();
        OnRotIdValueChanged();
        OnTypeIdValueChanged();
    }
    
    public void OnIterValueChanged()
    {
         _shaderRenderer.material.SetInt("_Iteration", (int)_iterSlider.value);
    }
    public void OnRotIdValueChanged()
    {
         _shaderRenderer.material.SetInt("_BulbTypeByRots", (int)_rotSlider.value);
    }
    public void OnTypeIdValueChanged()
    {
         _shaderRenderer.material.SetInt("_BulbType", (int)_typeSlider.value);
    }
}
