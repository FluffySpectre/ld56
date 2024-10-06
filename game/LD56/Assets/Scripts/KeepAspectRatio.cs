using UnityEngine;

public class KeepAspectRatio : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        // The desired aspect ratio is 320 / 240 = 4 / 3
        // Adjust the screen resul

        Screen.SetResolution(320, 240, Screen.fullScreen);
    }
}
