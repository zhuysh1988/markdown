Tag existing images into image streams 

The tag command allows you to take an existing tag or image from an image stream, or a Docker image pull spec, and set it as the most recent image for a tag in 1 or more other image streams. It is similar to the 'docker tag' command, but it operates on image streams instead. 

Pass the --insecure flag if your external registry does not have a valid HTTPS certificate, or is only served over HTTP. Pass --scheduled to have the server regularly check the tag for updates and import the latest version (which can then trigger builds and deployments). Note that --scheduled is only allowed for Docker images.

Usage:
  oc tag [--source=SOURCETYPE] SOURCE DEST [DEST ...] [options]

Examples:
  # Tag the current image for the image stream 'openshift/ruby' and tag '2.0' into the image stream 'yourproject/ruby with tag 'tip'.
  oc tag openshift/ruby:2.0 yourproject/ruby:tip
  
  # Tag a specific image.
  oc tag openshift/ruby@sha256:6b646fa6bf5e5e4c7fa41056c27910e679c03ebe7f93e361e6515a9da7e258cc yourproject/ruby:tip
  
  # Tag an external Docker image.
  oc tag --source=docker openshift/origin:latest yourproject/ruby:tip
  
  # Tag an external Docker image and request pullthrough for it.
  oc tag --source=docker openshift/origin:latest yourproject/ruby:tip --reference-policy=local
  
  # Remove the specified spec tag from an image stream.
  oc tag openshift/origin:latest -d

Options:
      --alias=false: Should the destination tag be updated whenever the source tag changes. Applies only to a single image stream. Defaults to false.
  -d, --delete=false: Delete the provided spec tags.
      --insecure=false: Set to true if importing the specified Docker image requires HTTP or has a self-signed certificate. Defaults to false.
      --reference=false: Should the destination tag continue to pull from the source namespace. Defaults to false.
      --reference-policy='source': Allow to request pullthrough for external image when set to 'local'. Defaults to 'source'.
      --scheduled=false: Set a Docker image to be periodically imported from a remote repository. Defaults to false.
      --source='': Optional hint for the source type; valid values are 'imagestreamtag', 'istag', 'imagestreamimage', 'isimage', and 'docker'.

Use "oc options" for a list of global command-line options (applies to all commands).
