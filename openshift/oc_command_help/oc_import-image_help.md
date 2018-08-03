Import the latest image information from a tag in a Docker registry 

Image streams allow you to control which images are rolled out to your builds and applications. This command fetches the latest version of an image from a remote repository and updates the image stream tag if it does not match the previous value. Running the command multiple times will not create duplicate entries. When importing an image, only the image metadata is copied, not the image contents. 

If you wish to change the image stream tag or provide more advanced options, see the 'tag' command.

Usage:
  oc import-image IMAGESTREAM[:TAG] [options]

Examples:
  oc import-image mystream

Options:
      --all=false: If true, import all tags from the provided source on creation or if --from is specified
      --confirm=false: If true, allow the image stream import location to be set or changed
      --dry-run=false: Fetch information about images without creating or updating an image stream.
      --from='': A Docker image repository to import images from
      --insecure=false: If true, allow importing from registries that have invalid HTTPS certificates or are hosted via HTTP. This flag will take precedence over the insecure annotation.
      --reference-policy='source': Allow to request pullthrough for external image when set to 'local'. Defaults to 'source'.
      --scheduled=false: Set each imported Docker image to be periodically imported from a remote repository. Defaults to false.

Use "oc options" for a list of global command-line options (applies to all commands).
