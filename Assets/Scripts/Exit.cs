using UnityEngine;

using System.Collections;



public class Exit : MonoBehaviour 

{
	
	void Update() 
	
	{
		
		if( Input.GetKey( KeyCode.Escape ) ) 
			Application.Quit();
	}

}
