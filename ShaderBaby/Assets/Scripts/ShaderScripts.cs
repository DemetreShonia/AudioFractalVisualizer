using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShaderScripts : MonoBehaviour
{
    Renderer rend;
    [SerializeField] Vector2 _minMaxIter;
    [SerializeField] Vector2 _minMaxSize;
    void Start() 
    {
        rend = GetComponent<Renderer> ();
    }
    float _currentMoveness = 0f;
    public void SetBulbScale(float scale)
    {
        _currentMoveness += scale * Time.deltaTime;
         rend.material.SetFloat("_Moveness", Mathf.Abs(_currentMoveness));
       // rend.material.SetFloat("_BulbScale", Mathf.Abs(scale * 1.5f));
        //rend.material.SetColor("_StartColor", Random.ColorHSV());
       // rend.material.SetFloat("_BulbScale", Mathf.Lerp(_minMaxSize.x, _minMaxSize.y, scale));
    }
}
