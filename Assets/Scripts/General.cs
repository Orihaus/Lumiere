using UnityEngine;
using System.Collections;

public class General : MonoBehaviour 
{
	public Camera cam;
	
	void Start() 
	{
		Screen.lockCursor = true;
		Application.targetFrameRate = 60;
		//cam.transparencySortMode = TransparencySortMode.Orthographic;
	}
	
    void Update() 
	{
        Screen.lockCursor = true;
    }
}
