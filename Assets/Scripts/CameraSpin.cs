using UnityEngine;
using System.Collections.Generic;
using System.Collections;

public class CameraSpin : MonoBehaviour 
{
	public Vector2 MouseSensitivity = new Vector2( 5.0f, 5.0f );
	public int MouseSmoothSteps = 10;
	public float MouseSmoothWeight = 0.5f;
	
	private Vector2 mouseMove = Vector2.zero;
	private List<Vector2> mouseSmoothBuffer = new List<Vector2>();
	private float pitch = 0.0f;
	private float yaw = 0.0f;
	private Vector2 initialRotation = Vector2.zero;
	
	void Awake()
	{
		initialRotation = new Vector2( transform.eulerAngles.y, transform.eulerAngles.x );
	}

    void FixedUpdate()
    {
		mouseMove.x = Input.GetAxis( "Mouse X" );
		mouseMove.y = Input.GetAxis( "Mouse Y" );

		while( mouseSmoothBuffer.Count > MouseSmoothSteps )
			mouseSmoothBuffer.RemoveAt( 0 );
		mouseSmoothBuffer.Add( mouseMove );

		float weight = 1;
		Vector2 average = Vector2.zero;
		float averageTotal = 0.0f;
		for( int i = mouseSmoothBuffer.Count - 1; i > 0; i-- )
		{
			average += mouseSmoothBuffer[i] * weight;
			averageTotal += ( 1.0f * weight );
			weight *= ( MouseSmoothWeight / ( Time.deltaTime * 60.0f ) );
		}

		// Store the average
		averageTotal = Mathf.Max( 1, averageTotal );
		Vector2 input = ( average / averageTotal );

		yaw += input.x * MouseSensitivity.x;
		pitch += input.y * MouseSensitivity.y;
		
		Vector2 rotationPitchLimit = new Vector2( -90.0f, 90.0f );
		Vector2 rotationYawLimit = new Vector2( -360.0f, 360.0f );
		
		yaw = yaw < -360F ? yaw += 360F : yaw;
		yaw = yaw > 360F ? yaw -= 360F : yaw;
		yaw = Mathf.Clamp( yaw, rotationYawLimit.x, rotationYawLimit.y );
		pitch = pitch < -360F ? pitch += 360F : pitch;
		pitch = pitch > 360F ? pitch -= 360F : pitch;
		pitch = Mathf.Clamp( pitch, rotationPitchLimit.x, rotationPitchLimit.y );
    }
	
	void LateUpdate()
	{
		Quaternion xq = Quaternion.AngleAxis( yaw + initialRotation.x, Vector3.up );
		Quaternion yq = Quaternion.AngleAxis( 0, Vector3.left );
		transform.rotation = xq * yq;

		// Pitch and yaw the camera
		yq = Quaternion.AngleAxis( pitch - initialRotation.y, Vector3.left );
		transform.rotation = xq * yq;
		
	}
}
