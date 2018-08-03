Cancel running, pending, or new builds 

This command requests a graceful shutdown of the build. There may be a delay between requesting the build and the time the build is terminated.

Usage:
  oc cancel-build (BUILD | BUILDCONFIG) [options]

Examples:
  # Cancel the build with the given name
  oc cancel-build ruby-build-2
  
  # Cancel the named build and print the build logs
  oc cancel-build ruby-build-2 --dump-logs
  
  # Cancel the named build and create a new one with the same parameters
  oc cancel-build ruby-build-2 --restart
  
  # Cancel multiple builds
  oc cancel-build ruby-build-1 ruby-build-2 ruby-build-3
  
  # Cancel all builds created from 'ruby-build' build configuration that are in 'new' state
  oc cancel-build bc/ruby-build --state=new

Options:
      --dump-logs=false: Specify if the build logs for the cancelled build should be shown.
      --restart=false: Specify if a new build should be created after the current build is cancelled.
      --state=[]: Only cancel builds in this state

Use "oc options" for a list of global command-line options (applies to all commands).
