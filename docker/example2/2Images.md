## How Packer’s Docker Builder Works

1. **Base Image Usage:**  
   Packer begins by pulling (or referencing) the base Docker image, such as `ubuntu:jammy`, from your local Docker repository or Docker Hub. This image serves as the starting point and remains unchanged.

2. **Provisioning in a Temporary Container:**  
   Packer launches a temporary container based on that base image. It then executes your provisioners (for example, a shell script that creates a file or sets an environment variable) within this container to modify its state.

3. **Committing the Changes:**  
   After the provisioners have run successfully, the Docker builder commits the modified container as a new image. This new image includes all changes made during the provisioning step.

---

## Result: Two Images

- **The Source Image:**  
  This is the original base image (e.g., `ubuntu:jammy`). It is preserved unchanged in your Docker repository and serves as the reference point for the new build.

- **The New Image:**  
  This is the final image that includes the modifications made by your provisioner, such as the file you created. This image is created by committing the modified container.

This behavior is by design. Packer’s Docker builder does not modify the base image; instead, it layers changes on top of it by creating a new image. As a result, both images coexist in your Docker environment:

- The base image is available for reuse or as a fallback.
- The newly built image, which contains your customizations, is ready for deployment or further testing.

---

## Key Points to Verify

- **Commit Option:** Ensure that your Docker builder configuration has `commit = true` so that the container modifications are saved as a new image.
- **Inspection:** You can verify the changes by running an interactive shell on the new image (using its image ID) to confirm that the file created by your provisioner exists.

This dual-image behavior is standard when using Packer with Docker and ensures a clean separation between the unmodified base image and your customized final image.

---

When you set `commit = false` in your Docker builder configuration, Packer will run the container and execute all provisioners, but it will not commit those changes to create a new image. Here’s what that means in detail:

- **No New Image Created:**  
  The container, even after having changes applied by your provisioners (for example, a file or environment variable), will not be saved as a new Docker image. The base image remains unchanged.

- **Ephemeral Changes:**  
  Any modifications made to the container during the provisioning phase are temporary. Once the build process completes, those changes are discarded along with the container instance.

- **Use Cases:**  
  - **Testing:** This can be useful when you want to test your provisioning scripts without producing a new image every time.  
  - **Non-Persistent Operations:** If your process requires running some configuration steps without the need to preserve the container as an artifact, using `commit = false` makes sense.

- **Artifact Output:**  
  With `commit = true` (the default behavior), Packer outputs a new image artifact that you can inspect or deploy. However, with `commit = false`, you won't have this new image artifact available, as the modifications are not persisted.

In summary, setting `commit = false` is a way to run provisioning tasks in a disposable container without generating a new, permanent Docker image.

---

The first image is the original base image that Packer uses to start the build process—in your example, it's the Docker image (e.g., `ubuntu:jammy`) that is pulled from a registry. This image remains unchanged and is not modified by the provisioning steps. Instead, Packer launches a temporary container based on this base image, applies your shell provisioner to customize it, and then commits the modified container as a new image. 

Here’s a breakdown of the roles of the two images:

- **The First Image (Source/Base Image):**  
  - It is the original Docker image you specified in your Packer configuration.
  - This image is downloaded or referenced as-is and remains intact.
  - It serves as the starting point for the provisioning process but is not altered.

- **The Second Image (Customized/Provisioned Image):**  
  - It is created when Packer commits the temporary container after running your provisioner.
  - This image incorporates all the changes made during the provisioning (e.g., the new file or environment variable), making it a modified version of the first image.
  - This is the final image artifact that includes your customizations and is intended for deployment.

In essence, the first image represents the untouched base image, while the second one is the result of your provisioning efforts applied to that base image.