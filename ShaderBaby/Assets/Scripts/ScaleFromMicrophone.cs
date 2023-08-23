using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScaleFromMicrophone : MonoBehaviour
{
    public AudioSource source;
    public Vector3 minScale;
    public Vector3 maxScale;
    public AudioDetection detector;
    public ShaderScripts _shaderScript;

    public float loudnessSensibility = 100;
    public float threshold =0.1f;
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        float loudness = detector.GetLoudnessFromMicrophone() * loudnessSensibility;
        if(loudness < threshold)
            loudness = 0;

        // transform.localScale = Vector3.one * loudness / 10f;
        _shaderScript.SetBulbScale(loudness);
    }
}
