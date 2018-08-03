Forward 1 or more local ports to a pod

Usage:
  oc port-forward POD [LOCAL_PORT:]REMOTE_PORT [...[LOCAL_PORT_N:]REMOTE_PORT_N] [options]

Examples:
  # Listens on ports 5000 and 6000 locally, forwarding data to/from ports 5000 and 6000 in the pod
  oc port-forward mypod 5000 6000
  
  # Listens on port 8888 locally, forwarding to 5000 in the pod
  oc port-forward mypod 8888:5000
  
  # Listens on a random port locally, forwarding to 5000 in the pod
  oc port-forward mypod :5000
  
  # Listens on a random port locally, forwarding to 5000 in the pod
  oc port-forward mypod 0:5000

Options:
  -p, --pod='': Pod name (deprecated)

Use "oc options" for a list of global command-line options (applies to all commands).
