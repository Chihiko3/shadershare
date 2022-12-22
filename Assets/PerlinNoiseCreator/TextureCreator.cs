using UnityEngine;

public class TextureCreator : MonoBehaviour
{
    [Range(2,512)]
    public int resolution = 256;
    private Texture2D texture;

    private void OnEnable()
    {
        texture = new Texture2D(resolution, resolution, TextureFormat.RGB24, true);
        texture.name = "Procedural Texture";
        texture.wrapMode = TextureWrapMode.Clamp;
        texture.filterMode = FilterMode.Bilinear;
        GetComponent<MeshRenderer>().material.mainTexture = texture;
        FillTexture();
    }

    public void FillTexture()
    {
        if (texture.width != resolution)
        {
            texture.Reinitialize(resolution, resolution);
        }
        float stepSize = 1f / resolution;
        for (int y = 0; y < resolution; y++)
        {
            for (int x = 0; x < resolution; x++)
            {
                texture.SetPixel(x,y,new Color((x+0.5f) * stepSize, (y+0.5f) *stepSize,0f)); // UV Coordinates
            }
        }
        texture.Apply();
    }



}
