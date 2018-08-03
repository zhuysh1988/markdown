Execute a command in a container

Usage:
  oc exec [options] POD [-c CONTAINER] -- COMMAND [args...]

Examples:
  # Get output from running 'date' in ruby-container from pod 'mypod'
  oc exec mypod -c ruby-container date
  
  # Switch to raw terminal mode, sends stdin to 'bash' in ruby-container from pod 'mypod' and sends stdout/stderr from 'bash' back to the client
  oc exec mypod -c ruby-container -i -t -- bash -il

Options:
  -c, --container='': Container name. If omitted, the first container in the pod will be chosen
  -p, --pod='': Pod name (deprecated)
  -i, --stdin=false: Pass stdin to the container
  -t, --tty=false: Stdin is a TTY

Use "oc options" for a list of global command-line options (applies to all commands).
