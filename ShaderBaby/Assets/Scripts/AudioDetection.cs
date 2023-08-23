using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioDetection : MonoBehaviour
{
    AudioClip microphoneClip;
    public int sampleWindow = 64; // amount of data we collect before clip position
    // Start is called before the first frame update
    void Start()
    {
        MicrophoneToAudioClip();
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    public void MicrophoneToAudioClip()
    {
        string microphoneName = Microphone.devices[0];
        microphoneClip = Microphone.Start(microphoneName, true, 20, AudioSettings.outputSampleRate);
    }

    public float GetLoudnessFromMicrophone()
    {
        // print(Microphone.GetPosition(Microphone.devices[0]) );
        return GetLoudnessFromAudioClip(Microphone.GetPosition(Microphone.devices[0]), microphoneClip);
    }
    public float GetLoudnessFromAudioClip(int clipPosition, AudioClip clip)
    {
        // clip pos in audio, where to check loudness
        // clip itself
        // we want to check area near that position and collect loudness info into an array
    
        int startPosition = clipPosition - sampleWindow;

        if(startPosition < 0) return 0;

        float[] waveData = new float[sampleWindow];

        clip.GetData(waveData, startPosition);

        //compute loudness
        float totalLoudness = 9;
        
        for(int i = 0; i <sampleWindow; i++)
        {
            totalLoudness += Mathf.Abs(waveData[i]); // abs because -1....1
        }
        return totalLoudness/sampleWindow; // get percent?
    }
}
