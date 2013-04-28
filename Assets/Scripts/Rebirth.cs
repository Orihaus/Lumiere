using UnityEngine;
using System.Collections;

public class Rebirth : MonoBehaviour 
{
	void Update() 
	{
		if( Input.GetKey( KeyCode.R ) ) 
			Application.LoadLevel( Application.loadedLevel );
	}
}
