using UnityEngine;
using System.Collections;

public class FlickerLight : MonoBehaviour
{
	public float BrightnessOne = 2.0f;
	public float BrightnessTwo = 0.0f;
	public float CoolDown = 0.1f;
	
	private float CurrentCoolDown = 0.0f;
	private bool CurrentBrightnessOne = false;

	void Update()
	{
		CurrentCoolDown -= Time.deltaTime;
		
		if( CurrentCoolDown < 0.0f )
		{
			CurrentBrightnessOne = !CurrentBrightnessOne;
			if( CurrentBrightnessOne )
				gameObject.light.intensity = BrightnessOne;
			else
				gameObject.light.intensity = BrightnessTwo;
			
			CurrentCoolDown = Random.value * CoolDown;
		}
	}
}
