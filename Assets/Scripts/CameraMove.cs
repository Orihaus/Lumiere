using UnityEngine;
using System.Collections.Generic;
using System.Collections;

public class CameraMove : MonoBehaviour 
{
	public float Speed = 1.0f;
	private Vector3 move;

    void FixedUpdate()
    {
		move.x = Input.GetAxis( "Horizontal" );
		move.y = 0.0f;
		move.z = Input.GetAxis( "Vertical" );
    }
	
	void LateUpdate()
	{
		transform.Translate( move * Speed );
	}
}
