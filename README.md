## PHP executable for users who don't want to download PHP:

**Ubuntu:**
Copy php-ubuntu file to path: /usr/local/bin/php

`sudo cp -i ~/your-download-location/php-ubuntu /usr/local/bin/php`

Grant executable permissions: `sudo chmod +x /usr/local/bin/php`

Running 'php -v' the first time will bring down the image.

Running 'php -v' a second time will give the php version.


**Mac:**

- Prerequisites: install Docker Desktop (or Colima + Docker) and ensure Docker is running.

- Copy the `php-ubuntu` helper to a directory on your PATH. Common destinations:

	- Intel macOS or general: `/usr/local/bin`

		`sudo cp -i ~/your-download-location/php-ubuntu /usr/local/bin/php`

	- Homebrew on Apple Silicon (if you use Homebrew): `/opt/homebrew/bin`

		`sudo cp -i ~/your-download-location/php-ubuntu /opt/homebrew/bin/php`

- Make the helper executable:

	`sudo chmod +x /usr/local/bin/php`

- Verify by running `php -v`. The first run will pull the PHP container image; subsequent runs will show the PHP version.

- If you prefer Podman, replace `docker` with `podman` and ensure your Podman setup supports macOS.




**Windows:**
instructions coming soon





**Changing PHP versions:**
The container called for this project comes from https://hub.docker.com/_/php

**Uninstall / Remove**

- **Remove the wrapper script:**

	- Delete the `php` helper copied to `/usr/local/bin`: `sudo rm -f /usr/local/bin/php`

- **Remove containers created from the `php` image:**

	- Stop running containers created from the `php` image (if any):

		`docker stop $(docker ps --filter ancestor=php -q)`

	- Remove stopped containers created from the `php` image:

		`docker rm $(docker ps -a --filter ancestor=php -q)`

- **Remove the local `php` image (optional):**

	- List `php` images: `docker images php`

	- Remove by name or ID: `docker rmi php` or `docker rmi <IMAGE_ID>`

- **Alternative (Podman):** replace `docker` with `podman` in the commands above.

- **Quick cleanup (destructive):**

	- Remove all unused images, containers and networks (careful): `docker system prune -a`

These steps remove the wrapper script and any locally cached `php` container images/containers. Only run the image-removal commands if you know you no longer need the pulled PHP images.
