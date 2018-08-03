Set a new size for a deployment or replication controller 

Scale also allows users to specify one or more preconditions for the scale action. If --current-replicas or --resource-version is specified, it is validated before the scale is attempted, and it is guaranteed that the precondition holds true when the scale is sent to the server. 

Note that scaling a deployment configuration with no deployments will update the desired replicas in the configuration template. 

Supported resources: ["deployment" "replicaset" "replicationcontroller" "job" "statefulset" "deploymentconfig"]

Usage:
  oc scale [--resource-version=version] [--current-replicas=count] --replicas=COUNT (-f FILENAME | TYPE NAME) [options]

Examples:
  # Scale replication controller named 'foo' to 3.
  oc scale --replicas=3 replicationcontrollers foo
  
  # If the replication controller named foo's current size is 2, scale foo to 3.
  oc scale --current-replicas=2 --replicas=3 replicationcontrollers foo
  
  # Scale the latest deployment of 'bar'. In case of no deployment, bar's template
  # will be scaled instead.
  oc scale --replicas=10 dc bar

Options:
      --all=false: Select all resources in the namespace of the specified resource types
      --current-replicas=-1: Precondition for current size. Requires that the current size of the resource match this value in order to scale.
  -f, --filename=[]: Filename, directory, or URL to files identifying the resource to set a new size
      --include-extended-apis=true: If true, include definitions of new APIs via calls to the API server. [default true]
  -o, --output='': Output mode. Use "-o name" for shorter output (resource/name).
      --record=false: Record current kubectl command in the resource annotation. If set to false, do not record the command. If set to true, record the command. If not set, default to updating the existing annotation value only if one already exists.
  -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests organized within the same directory.
      --replicas=-1: The new desired number of replicas. Required.
      --resource-version='': Precondition for resource version. Requires that the current resource version match this value in order to scale.
  -l, --selector='': Selector (label query) to filter on, supports '=', '==', and '!='.(e.g. -l key1=value1,key2=value2)
      --timeout=0s: The length of time to wait before giving up on a scale operation, zero means don't wait. Any other values should contain a corresponding time unit (e.g. 1s, 2m, 3h).

Use "oc options" for a list of global command-line options (applies to all commands).
