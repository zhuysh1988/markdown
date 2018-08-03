Create a new build by specifying source code 

This command will try to create a build configuration for your application using images and code that has a public repository. It will lookup the images on the local Docker installation (if available), a Docker registry, or an image stream. 

If you specify a source code URL, it will set up a build that takes your source code and converts it into an image that can run inside of a pod. Local source must be in a git repository that has a remote repository that the server can see. 

Once the build configuration is created a new build will be automatically triggered. You can use 'oc status' to check the progress.

Usage:
  oc new-build (IMAGE | IMAGESTREAM | PATH | URL ...) [options]

Examples:
  # Create a build config based on the source code in the current git repository (with a public
  # remote) and a Docker image
  oc new-build . --docker-image=repo/langimage
  
  # Create a NodeJS build config based on the provided [image]~[source code] combination
  oc new-build openshift/nodejs-010-centos7~https://github.com/openshift/nodejs-ex.git
  
  # Create a build config from a remote repository using its beta2 branch
  oc new-build https://github.com/openshift/ruby-hello-world#beta2
  
  # Create a build config using a Dockerfile specified as an argument
  oc new-build -D $'FROM centos:7\nRUN yum install -y httpd'
  
  # Create a build config from a remote repository and add custom environment variables
  oc new-build https://github.com/openshift/ruby-hello-world -e RACK_ENV=development
  
  # Create a build config from a remote private repository and specify which existing secret to use
  oc new-build https://github.com/youruser/yourgitrepo --source-secret=yoursecret
  
  # Create a build config from a remote repository and inject the npmrc into a build
  oc new-build https://github.com/openshift/ruby-hello-world --build-secret npmrc:.npmrc
  
  # Create a build config that gets its input from a remote repository and another Docker image
  oc new-build https://github.com/openshift/ruby-hello-world --source-image=openshift/jenkins-1-centos7 --source-image-path=/var/lib/jenkins:tmp

Options:
      --allow-missing-images=false: If true, indicates that referenced Docker images that cannot be found locally or in a registry should still be used.
      --allow-missing-imagestream-tags=false: If true, indicates that image stream tags that don't exist should still be used.
      --binary=false: Instead of expecting a source URL, set the build to expect binary contents. Will disable triggers.
      --build-arg=[]: Specify a key-value pair to pass to Docker during the build.
      --build-secret=[]: Secret and destination to use as an input for the build.
      --code=[]: Source code in the build configuration.
      --context-dir='': Context directory to be used for the build.
      --docker-image=[]: Name of a Docker image to use as a builder.
  -D, --dockerfile='': Specify the contents of a Dockerfile to build directly, implies --strategy=docker. Pass '-' to read from STDIN.
      --dry-run=false: If true, show the result of the operation without performing it.
  -e, --env=[]: Specify a key-value pair for an environment variable to set into resulting image.
      --env-file=[]: File containing key-value pairs of environment variables to set into each container.
      --image=[]: Name of an image stream to to use as a builder. (deprecated)
  -i, --image-stream=[]: Name of an image stream to to use as a builder.
  -l, --labels='': Label to set in all generated resources.
      --name='': Set name to use for generated build artifacts.
      --no-output=false: If true, the build output will not be pushed anywhere.
  -o, --output='': Output results as yaml or json instead of executing, or use name for succint output (resource/name).
      --output-version='': The preferred API versions of the output objects
      --push-secret='': The name of an existing secret that should be used for pushing the output image.
  -a, --show-all=true: When printing, show all resources (false means hide terminated pods.)
      --show-labels=false: When printing, show all labels as the last column (default hide labels column)
      --sort-by='': If non-empty, sort list types using this field specification.  The field specification is expressed as a JSONPath expression (e.g. '{.metadata.name}'). The field in the API resource specified by this JSONPath expression must be an integer or a string.
      --source-image='': Specify an image to use as source for the build.  You must also specify --source-image-path.
      --source-image-path='': Specify the file or directory to copy from the source image and its destination in the build directory. Format: [source]:[destination-dir].
      --source-secret='': The name of an existing secret that should be used for cloning a private git repository.
      --strategy=: Specify the build strategy to use if you don't want to detect (docker|pipeline|source).
      --template='': Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format is golang templates [http://golang.org/pkg/text/template/#pkg-overview].
      --to='': Push built images to this image stream tag (or Docker image repository if --to-docker is set).
      --to-docker=false: If true, have the build output push to a Docker repository.

Use "oc options" for a list of global command-line options (applies to all commands).
