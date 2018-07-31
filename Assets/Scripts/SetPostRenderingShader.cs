using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SetPostRenderingShader : MonoBehaviour {

    public Material mat;

    private Camera cam;

	// Use this for initialization
	void Start () {
        cam = Camera.main;
	}
	
	// Update is called once per frame
	void Update () {
		
	}

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        Graphics.Blit(src, dest, mat);
    }
}
