Start a new rollout, view its status or history, rollback to a previous revision of your app 

This command allows you to control a deployment config. Each individual rollout is exposed as a replication controller, and the deployment process manages scaling down old replication controllers and scaling up new ones. 

There are several deployment strategies defined: 

  * Rolling (default) - scales up the new replication controller in stages, gradually reducing the number of old pods. If one of the new deployed pods never becomes "ready", the new rollout will be rolled back (scaled down to zero). Use when your application can tolerate two versions of code running at the same time (many web applications, scalable databases)  
  * Recreate - scales the old replication controller down to zero, then scales the new replication controller up to full. Use when your application cannot tolerate two versions of code running at the same time  
  * Custom - run your own deployment process inside a Docker container using your own scripts.

Usage:
  oc rollout SUBCOMMAND [options]

Available Commands:
  cancel      cancel the in-progress deployment
  history     View rollout history
  latest      Start a new rollout for a deployment config with the latest state from its triggers
  pause       Mark the provided resource as paused
  resume      Resume a paused resource
  retry       Retry the latest failed rollout
  status      Show the status of the rollout
  undo        Undo a previous rollout

Use "oc <command> --help" for more information about a given command.
Use "oc options" for a list of global command-line options (applies to all commands).
