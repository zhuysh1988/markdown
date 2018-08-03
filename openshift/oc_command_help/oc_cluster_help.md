Manage a local OpenShift cluster 

The OpenShift cluster will run as an all-in-one container on a Docker host. The Docker host may be a local VM (ie. using docker-machine on OS X and Windows clients), remote machine, or the local Unix host. 

Use the 'up' command to start a new cluster (master and node) on a single machine. Use the 'join' command on another machine to connect to the first cluster. 

To use an existing Docker connection, ensure that Docker commands are working and that you can create new containers. For OS X and Windows clients, a docker-machine with the VirtualBox driver can be created for you using the --create-machine option. 

By default, etcd data will not be preserved between container restarts. If you wish to preserve your data, specify a value for --host-data-dir and the --use-existing-config flag. 

Default routes are setup using nip.io and the host ip of your cluster. To use a different routing suffix, use the --routing-suffix flag.

Usage:
  oc cluster ACTION [options]

Available Commands:
  down        Stop OpenShift on Docker
  join        Join an existing OpenShift cluster
  status      Show OpenShift on Docker status
  up          Start OpenShift on Docker with reasonable defaults

Use "oc <command> --help" for more information about a given command.
Use "oc options" for a list of global command-line options (applies to all commands).
