## PHP executable for users who don't want to download PHP:

**Linux / Mac (`php-unix`):**

- Prerequisites: install Docker (Docker Desktop on Mac, or Docker Engine on Linux) and ensure the Docker daemon is running. On Mac, Colima + Docker also works.

- **Linux only:** add your user to the `docker` group so the wrapper can access Docker without `sudo`:

    `sudo usermod -aG docker $USER`

    Then **log out and back in** (or run `newgrp docker`) for the group change to take effect.

- Copy the `php-unix` file to a directory on your `PATH`, named `php`. Common destinations:

    - Linux, or Intel Mac: `/usr/local/bin`

        `sudo cp -i ~/your-download-location/php-unix /usr/local/bin/php`

    - Homebrew on Apple Silicon (if you use Homebrew): `/opt/homebrew/bin`

        `sudo cp -i ~/your-download-location/php-unix /opt/homebrew/bin/php`

- Grant executable permissions:

    `sudo chmod +x /usr/local/bin/php`

- Verify by running `php -v`. The first run will pull the PHP container image; subsequent runs will show the PHP version.

- If you prefer Podman, replace `docker` with `podman` in the script and ensure your Podman setup supports your OS.

**Windows (`php-windows.cmd`):**

- Prerequisites: install Docker Desktop and ensure it's running, with the Linux containers backend enabled (the default).

- Copy `php-windows.cmd` to a directory on your `PATH`, renamed to `php.cmd`. For example, create `C:\tools\php` and copy it there:

    ```bat
    mkdir C:\tools\php
    copy php-windows.cmd C:\tools\php\php.cmd
    ```

- Add that directory to your `PATH` (System Properties → Environment Variables, or from an elevated PowerShell prompt):

    ```bat
    setx PATH "%PATH%;C:\tools\php"
    ```

    Then open a new terminal window for the change to take effect. (If you'd rather not risk `setx` truncating a long `PATH`, add the directory instead via System Properties → Environment Variables → Edit.)

- Verify by running `php -v` from Command Prompt or PowerShell. The first run will pull the PHP container image; subsequent runs will show the PHP version.

**Changing PHP versions:**

The container used for this project comes from https://hub.docker.com/_/php. Edit the image tag (e.g. `php:8.4.18-zts-alpine3.22`) inside the wrapper script for your platform to change versions.

**Uninstall / Remove**

- **Remove the wrapper script:**

    - Linux/Mac: `sudo rm -f /usr/local/bin/php` (or `/opt/homebrew/bin/php` on Apple Silicon Homebrew installs)
    - Windows: delete `php.cmd` from the directory you added to `PATH` (e.g. `C:\tools\php`)

- **Remove containers created from the `php` image:**

    - Stop running containers created from the `php` image (if any):

        `docker stop $(docker ps --filter ancestor=php -q)`

    - Remove stopped containers created from the `php` image:

        `docker rm $(docker ps -a --filter ancestor=php -q)`

    (On Windows, run the equivalent `docker ps` / `docker stop` / `docker rm` commands directly, since `$()` command substitution isn't available in Command Prompt.)

- **Remove the local `php` image (optional):**

    - List `php` images: `docker images php`

    - Remove by name or ID: `docker rmi php` or `docker rmi <IMAGE_ID>`

- **Alternative (Podman):** replace `docker` with `podman` in the commands above.

- **Quick cleanup (destructive):**

    - Remove all unused images, containers and networks (careful): `docker system prune -a`

These steps remove the wrapper script and any locally cached `php` container images/containers. Only run the image-removal commands if you know you no longer need the pulled PHP images.
