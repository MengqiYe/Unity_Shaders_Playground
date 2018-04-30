using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AutoRotate : MonoBehaviour {
    [Range(.1f,10)]
    public float Speed = 1;
    private Transform trans;
	// Use this for initialization
	void Start () {
        trans = GetComponent<Transform>();
	}
	
	// Update is called once per frame
	void Update () {
        trans.Rotate(0, Speed, 0);
	}
}
