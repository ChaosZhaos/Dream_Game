using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlickerLight : MonoBehaviour {

	public float LightIntensity;
	private Light flickerlight;

	void Start () {
		flickerlight = GetComponent<Light> ();
		GetComponent<Animator> ().speed = Random.Range (0.8f, 1.2f);
	}
	
	void LateUpdate() {
		flickerlight.intensity = flickerlight.intensity * LightIntensity;
	}
}
