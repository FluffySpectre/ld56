using UnityEngine;

[RequireComponent(typeof(CharacterController))]
public class PlayerController : MonoBehaviour
{
    public float moveSpeed = 5f;
    public Transform flashLightTransform;
    public LayerMask mouseDetectionLayer;
    
    [Header("Debug")]
    public Transform debugFlashLightTargetIndicator;

    private CharacterController controller;
    private Vector3 flashLightTargetPosition;

    // Start is called before the first frame update
    void Start()
    {
        controller = GetComponent<CharacterController>();
    }

    void Update()
    {
        // Rotate the flashLightTransform towards the mouse position
        var mousePosition = Input.mousePosition;
        var ray = Camera.main.ScreenPointToRay(mousePosition);
        if (Physics.Raycast(ray, out RaycastHit hit, 1000f, mouseDetectionLayer))
        {
            flashLightTargetPosition = hit.point;
            debugFlashLightTargetIndicator.position = hit.point;
            
            // Rotate the flashlight towards the hit point and offset the rotation by 90 degrees on the x-axis
            flashLightTransform.LookAt(hit.point, Vector3.right);
            flashLightTransform.Rotate(Vector3.up, -90f);
        }



        // var mousePosition = Input.mousePosition;
        // var worldPosition = Camera.main.ScreenToWorldPoint(new Vector2(mousePosition.x, Screen.height - mousePosition.y));

        // flashLightTargetPosition = worldPosition;
        // debugFlashLightTargetIndicator.position = worldPosition;

        // flashLightTransform.LookAt(worldPosition, Vector3.right);
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        // Get input from player
        var horizontal = Input.GetAxis("Horizontal");
        var vertical = Input.GetAxis("Vertical");

        // Move the player
        controller.Move(new Vector3(0f, 0f, horizontal) * moveSpeed * Time.fixedDeltaTime);
    }

    void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawSphere(flashLightTargetPosition, 1f);
    }
}
