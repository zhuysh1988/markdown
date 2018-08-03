Copy local files to or from a pod container 

This command will copy local files to or from a remote container. It only copies the changed files using the rsync command from your OS. To ensure optimum performance, install rsync locally. In UNIX systems, use your package manager. In Windows, install cwRsync from https://www.itefix.net/cwrsync. 

If no container is specified, the first container of the pod is used for the copy.

Usage:
  oc rsync SOURCE DESTINATION [options]

Examples:
  # Synchronize a local directory with a pod directory
  oc rsync ./local/dir/ POD:/remote/dir
  
  # Synchronize a pod directory with a local directory
  oc rsync POD:/remote/dir/ ./local/dir

Options:
  -c, --container='': Container within the pod
      --delete=false: If true, delete files not present in source
      --exclude=[]: If true, exclude files matching specified pattern
      --include=[]: If true, include files matching specified pattern
      --no-perms=false: If true, do not transfer permissions
      --progress=false: If true, show progress during transfer
  -q, --quiet=false: Suppress non-error messages
      --strategy='': Specify which strategy to use for copy: rsync, rsync-daemon, or tar
  -w, --watch=false: Watch directory for changes and resync automatically

Use "oc options" for a list of global command-line options (applies to all commands).
