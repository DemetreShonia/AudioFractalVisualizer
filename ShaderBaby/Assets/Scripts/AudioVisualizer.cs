using UnityEngine;

public class AudioVisualizer : MonoBehaviour
{
	public AudioSource audioSource;
	public float updateStep = 0.1f;
	public int sampleDataLength = 1024;

	private float currentUpdateTime = 0f;

	public float clipLoudness;

	float _currentClipLoudness;
	private float[] clipSampleData;

	public ShaderScripts _fractalShader;
	public float sizeFactor = 1;

	public float minSize = 0;
	public float maxSize = 500;

	// Use this for initialization
	private void Awake()
	{
		clipSampleData = new float[sampleDataLength];
		

		// future?
		audioSource.clip.GetData(clipSampleData, audioSource.timeSamples); //I read 1024 samples, which is about 80 ms on a 44khz stereo clip, beginning at the current sample position of the clip.
	}
	void CalculateNextLoud()
	{
		audioSource.clip.GetData(clipSampleData, audioSource.timeSamples); //I read 1024 samples, which is about 80 ms on a 44khz stereo clip, beginning at the current sample position of the clip.
		clipLoudness = 0f;
		foreach (var sample in clipSampleData)
		{
			clipLoudness += Mathf.Abs(sample);
		}
		clipLoudness /= sampleDataLength; //clipLoudness is what you are looking for
		
		clipLoudness *= sizeFactor;
		clipLoudness = Mathf.Clamp(clipLoudness, minSize, maxSize);
	}

	private void Update()
	{
		currentUpdateTime += Time.deltaTime;
		if (currentUpdateTime >= updateStep)
		{
			currentUpdateTime = 0f;
			CalculateNextLoud();
		}
		else
		{
			_currentClipLoudness = Mathf.Lerp(_currentClipLoudness, clipLoudness, currentUpdateTime/updateStep);
			print(currentUpdateTime/updateStep);
		}
		
		_fractalShader.SetBulbScale(_currentClipLoudness);

	}
}