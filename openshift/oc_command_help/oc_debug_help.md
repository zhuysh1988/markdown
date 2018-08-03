Launch a command shell to debug a running application 

When debugging images and setup problems, it's useful to get an exact copy of a running pod configuration and troubleshoot with a shell. Since a pod that is failing may not be started and not accessible to 'rsh' or 'exec', the 'debug' command makes it easy to create a carbon copy of that setup. 

The default mode is to start a shell inside of the first container of the referenced pod, replication controller, or deployment config. The started pod will be a copy of your source pod, with labels stripped, the command changed to '/bin/sh', and readiness and liveness checks disabled. If you just want to run a command, add '--' and a command to run. Passing a command will not create a TTY or send STDIN by default. Other flags are supported for altering the container or pod in common ways. 

A common problem running containers is a security policy that prohibits you from running as a root user on the cluster. You can use this command to test running a pod as non-root (with --as-user) or to run a non-root pod as root (with --as-root). 

The debug pod is deleted when the the remote command completes or the user interrupts the shell.

Usage:
  oc debug RESOURCE/NAME [ENV1=VAL1 ...] [-c CONTAINER] [options] [-- COMMAND]

Examples:
  # Debug a currently running deployment
  oc debug dc/test
  
  # Test running a deployment as a non-root user
  oc debug dc/test --as-user=1000000
  
  # Debug a specific failing container by running the env command in the 'second' container
  oc debug dc/test -c second -- /bin/env
  
  # See the pod that would be created to debug
  oc debug dc/test -o yaml

Options:
      --as-root=false: If true, try to run the container as the root user
      --as-user=-1: Try to run the container as a specific user UID (note: admins may limit your ability to use this flag)
  -c, --container='': Container name; defaults to first container
  -f, --filename='': Filename or URL to file to read a template
      --keep-annotations=false: If true, keep the original pod annotations
      --keep-init-containers=true: Run the init containers for the pod. Defaults to true.
      --keep-liveness=false: If true, keep the original pod liveness probes
      --keep-readiness=false: If true, keep the original pod readiness probes
  -I, --no-stdin=false: Bypasses passing STDIN to the container, defaults to true if no command specified
  -T, --no-tty=false: Disable pseudo-terminal allocation
      --node-name='': Set a specific node to run on - by default the pod will run on any valid node
      --one-container=false: If true, run only the selected container, remove all others
  -o, --output='': Output format. One of: json|yaml|wide|name|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=... See golang template [http://golang.org/pkg/text/template/#pkg-overview] and jsonpath template [http://kubernetes.io/docs/user-guide/jsonpath/].
      --output-version='': Output the formatted object with the given version (default api-version).
      --show-labels=false: When printing, show all labels as the last column (default hide labels column)
      --template='': Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format is golang templates [http://golang.org/pkg/text/template/#pkg-overview].
  -t, --tty=false: Force a pseudo-terminal to be allocated

Use "oc options" for a list of global command-line options (applies to all commands).
