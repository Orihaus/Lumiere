using UnityEngine;
using System.Collections;

public class Spin : MonoBehaviour 
{
	public float Speed = 1.0f;
	public Vector3 Axis = Vector3.forward;
	
	void Update() 
	{
		transform.Rotate( Axis, Speed * Time.deltaTime );
	}
}
