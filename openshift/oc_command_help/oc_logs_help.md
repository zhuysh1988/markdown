Print the logs for a resource 

Supported resources are builds, build configs (bc), deployment configs (dc), and pods. When a pod is specified and has more than one container, the container name should be specified via -c. When a build config or deployment config is specified, you can view the logs for a particular version of it via --version. 

If your pod is failing to start, you may need to use the --previous option to see the logs of the last attempt.

Aliases:
logs, log

Usage:
  oc logs [-f] [-p] (POD | TYPE/NAME) [-c CONTAINER] [options]

Examples:
  # Start streaming the logs of the most recent build of the openldap build config.
  oc logs -f bc/openldap
  
  # Start streaming the logs of the latest deployment of the mysql deployment config.
  oc logs -f dc/mysql
  
  # Get the logs of the first deployment for the mysql deployment config. Note that logs
  # from older deployments may not exist either because the deployment was successful
  # or due to deployment pruning or manual deletion of the deployment.
  oc logs --version=1 dc/mysql
  
  # Return a snapshot of ruby-container logs from pod backend.
  oc logs backend -c ruby-container
  
  # Start streaming of ruby-container logs from pod backend.
  oc logs -f pod/backend -c ruby-container

Options:
  -c, --container='': Print the logs of this container
  -f, --follow=false: Specify if the logs should be streamed.
      --include-extended-apis=true: If true, include definitions of new APIs via calls to the API server. [default true]
      --interactive=false: If true, prompt the user for input when required.
      --limit-bytes=0: Maximum bytes of logs to return. Defaults to no limit.
      --pod-running-timeout=20s: The length of time (like 5s, 2m, or 3h, higher than zero) to wait until at least one pod is running
  -p, --previous=false: If true, print the logs for the previous instance of the container in a pod if it exists.
  -l, --selector='': Selector (label query) to filter on.
      --since=0s: Only return logs newer than a relative duration like 5s, 2m, or 3h. Defaults to all logs. Only one of since-time / since may be used.
      --since-time='': Only return logs after a specific date (RFC3339). Defaults to all logs. Only one of since-time / since may be used.
      --tail=-1: Lines of recent log file to display. Defaults to -1 with no selector, showing all log lines otherwise 10, if a selector is provided.
      --timestamps=false: Include timestamps on each line in the log output
      --version=0: View the logs of a particular build or deployment by version if greater than zero

Use "oc options" for a list of global command-line options (applies to all commands).
