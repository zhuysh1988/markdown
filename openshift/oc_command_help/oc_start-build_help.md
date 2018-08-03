Start a build 

This command starts a new build for the provided build config or copies an existing build using --from-build= <name>. Pass the --follow flag to see output from the build. 

In addition, you can pass a file, directory, or source code repository with the --from-file, --from-dir, or --from-repo flags directly to the build. The contents will be streamed to the build and override the current build source settings. When using --from-repo, the --commit flag can be used to control which branch, tag, or commit is sent to the server. If you pass --from-file, the file is placed in the root of an empty directory with the same filename. It is also possible to pass a http or https url to --from-file and --from-archive, however authentication is not supported and in case of https the certificate must be valid and recognized by your system. 

Note that builds triggered from binary input will not preserve the source on the server, so rebuilds triggered by base image changes will use the source specified on the build config.

Usage:
  oc start-build (BUILDCONFIG | --from-build=BUILD) [options]

Examples:
  # Starts build from build config "hello-world"
  oc start-build hello-world
  
  # Starts build from a previous build "hello-world-1"
  oc start-build --from-build=hello-world-1
  
  # Use the contents of a directory as build input
  oc start-build hello-world --from-dir=src/
  
  # Send the contents of a Git repository to the server from tag 'v2'
  oc start-build hello-world --from-repo=../hello-world --commit=v2
  
  # Start a new build for build config "hello-world" and watch the logs until the build
  # completes or fails.
  oc start-build hello-world --follow
  
  # Start a new build for build config "hello-world" and wait until the build completes. It
  # exits with a non-zero return code if the build fails.
  oc start-build hello-world --wait

Options:
      --build-arg=[]: Specify a key-value pair to pass to Docker during the build.
      --build-loglevel='': Specify the log level for the build log output
      --commit='': Specify the source code commit identifier the build should use; requires a build based on a Git repository
  -e, --env=[]: Specify a key-value pair for an environment variable to set for the build container.
  -F, --follow=false: Start a build and watch its logs until it completes or fails
      --from-archive='': An archive (tar, tar.gz, zip) to be extracted before the build and used as the binary input.
      --from-build='': Specify the name of a build which should be re-run
      --from-dir='': A directory to archive and use as the binary input for a build.
      --from-file='': A file to use as the binary input for the build; example a pom.xml or Dockerfile. Will be the only file in the build source.
      --from-repo='': The path to a local source code repository to use as the binary input for a build.
      --from-webhook='': Specify a generic webhook URL for an existing build config to trigger
      --git-post-receive='': The contents of the post-receive hook to trigger a build
      --git-repository='': The path to the git repository for post-receive; defaults to the current directory
      --incremental=false: Overrides the incremental setting in a source-strategy build, ignored if not specified
      --list-webhooks='': List the webhooks for the specified build config or build; accepts 'all', 'generic', or 'github'
      --no-cache=false: Overrides the noCache setting in a docker-strategy build, ignored if not specified
  -o, --output='': Output mode. Use "-o name" for shorter output (resource/name).
  -w, --wait=false: Wait for a build to complete and exit with a non-zero return code if the build fails

Use "oc options" for a list of global command-line options (applies to all commands).
