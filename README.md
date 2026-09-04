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

- If `php -v` fails with an image/platform error, Docker Desktop may be set to Windows containers instead of Linux containers (the `php` image is Linux-based). Right-click the Docker Desktop tray icon and choose **Switch to Linux containers...**, then try again.

**Changing PHP versions:**

The container used for this project comes from https://hub.docker.com/_/php. Edit the image tag (e.g. `php:8.4.18-zts-alpine3.22`) inside the wrapper script for your platform to change versions.

**Uninstall / Remove**

- **Remove the wrapper script:**

    - Linux/Mac: `sudo rm -f /usr/local/bin/php` (or `/opt/homebrew/bin/php` on Apple Silicon Homebrew installs)
    - Windows: delete `php.cmd` from the directory you added to `PATH` (e.g. `C:\tools\php`)

- **Remove containers created from the `php` image:**

    The wrapper scripts run with `--rm`, so containers are normally cleaned up automatically as soon as they exit. These commands only matter if one was killed abnormally (e.g. the host crashed mid-run) and got left behind.

    - Stop running containers created from the `php` image (if any):

        `docker stop $(docker ps --filter ancestor=php:8.4.18-zts-alpine3.22 -q)`

    - Remove stopped containers created from the `php` image:

        `docker rm $(docker ps -a --filter ancestor=php:8.4.18-zts-alpine3.22 -q)`

    (The `ancestor` filter needs the full `image:tag` — a bare `ancestor=php` matches nothing unless you're on the `:latest` tag, which this project doesn't use. Match the tag to whatever version you're actually running; see "Changing PHP versions" above. On Windows, run the equivalent `docker ps` / `docker stop` / `docker rm` commands directly, since `$()` command substitution isn't available in Command Prompt.)

- **Remove the local `php` image (optional):**

    - List `php` images: `docker images php`

    - Remove by name or ID: `docker rmi php` or `docker rmi <IMAGE_ID>`

- **Alternative (Podman):** replace `docker` with `podman` in the commands above.

- **Quick cleanup (destructive):**

    - Remove all unused images, containers and networks (careful): `docker system prune -a`

These steps remove the wrapper script and any locally cached `php` container images/containers. Only run the image-removal commands if you know you no longer need the pulled PHP images.

**Continuous Integration**

[`.github/workflows/smoke-test.yml`](.github/workflows/smoke-test.yml) runs both wrapper scripts against the real `php` Docker image on every push and pull request — not just that they run, but that the `$HOME`/`%USERPROFILE%` and `$PWD`/`%CD%` mounts actually land where they're supposed to. The Linux job doubles as the closest available check for `php-unix` on Mac too, since GitHub-hosted macOS runners don't support Docker at all (no nested virtualization) — Mac itself isn't CI-tested.

The Windows job (`php-windows.cmd`) took a few iterations to get working, for reasons worth recording:

1. `windows-latest` runners ship a Docker Engine defaulted to **Windows containers**, not Linux containers, so the `php` (Linux/Alpine-based) image can't run until that's switched.
2. There's no Docker Desktop installed on that runner image to do the switch with — only the underlying Moby engine — so the fix is to install Docker Desktop in the job itself and wait for its Linux engine to come up before running anything.
3. Once that was working, the job still failed — but the failure was in the test script, not the wrapper: `$out = & command` in PowerShell returns multi-line output as a string array, and `-match`/`-notmatch` against an array filters elements rather than returning a boolean. A "no line matches" result rendered as a non-empty (truthy) array, so the check false-failed even though `php -v` had printed the correct version. Fixed by joining the output to a single string before matching.
