Observe changes to resources and take action on them 

This command assists in building scripted reactions to changes that occur in Kubernetes or OpenShift resources. This is frequently referred to as a 'controller' in Kubernetes and acts to ensure particular conditions are maintained. On startup, observe will list all of the resources of a particular type and execute the provided script on each one. Observe watches the server for changes, and will reexecute the script for each update. 

Observe works best for problems of the form "for every resource X, make sure Y is true". Some examples of ways observe can be used include: 

  * Ensure every namespace has a quota or limit range object  
  * Ensure every service is registered in DNS by making calls to a DNS API  
  * Send an email alert whenever a node reports 'NotReady'  
  * Watch for the 'FailedScheduling' event and write an IRC message  
  * Dynamically provision persistent volumes when a new PVC is created  
  * Delete pods that have reached successful completion after a period of time.  

The simplest pattern is maintaining an invariant on an object - for instance, "every namespace should have an annotation that indicates its owner". If the object is deleted no reaction is necessary. A variation on that pattern is creating another object: "every namespace should have a quota object based on the resources allowed for an owner". 

  $ cat set_owner.sh
  #!/bin/sh
  if [[ "$(oc get namespace "$1" --template='{{ .metadata.annotations.owner }}')" == "" ]]; then
    oc annotate namespace "$1" owner=bob
  fi
  
  $ oc observe namespaces -- ./set_owner.sh
  
The set _owner.sh script is invoked with a single argument (the namespace name) for each namespace. This simple script ensures that any user without the "owner" annotation gets one set, but preserves any existing value. 

The next common of controller pattern is provisioning - making changes in an external system to match the state of a Kubernetes resource. These scripts need to account for deletions that may take place while the observe command is not running. You can provide the list of known objects via the --names command, which should return a newline-delimited list of names or namespace/name pairs. Your command will be invoked whenever observe checks the latest state on the server - any resources returned by --names that are not found on the server will be passed to your --delete command. 

For example, you may wish to ensure that every node that is added to Kubernetes is added to your cluster inventory along with its IP: 

  $ cat add_to_inventory.sh
  #!/bin/sh
  echo "$1 $2" >> inventory
  sort -u inventory -o inventory
  
  $ cat remove_from_inventory.sh
  #!/bin/sh
  grep -vE "^$1 " inventory > /tmp/newinventory
  mv -f /tmp/newinventory inventory
  
  $ cat known_nodes.sh
  #!/bin/sh
  touch inventory
  cut -f 1-1 -d ' ' inventory
  
  $ oc observe nodes -a '{ .status.addresses[0].address }' \
    --names ./known_nodes.sh \
    --delete ./remove_from_inventory.sh \
    -- ./add_to_inventory.sh
  
If you stop the observe command and then delete a node, when you launch observe again the contents of inventory will be compared to the list of nodes from the server, and any node in the inventory file that no longer exists will trigger a call to remove from inventory.sh with the name of the node. 

Important: when handling deletes, the previous state of the object may not be available and only the name/namespace of the object will be passed to   your --delete command as arguments (all custom arguments are omitted). 

More complicated interactions build on the two examples above - your inventory script could make a call to allocate storage on your infrastructure as a service, or register node names in DNS, or set complex firewalls. The more complex your integration, the more important it is to record enough data in the remote system that you can identify when resources on either side are deleted. 

Experimental: This command is under active development and may change without notice.

Usage:
  oc observe RESOURCE [-- COMMAND ...] [options]

Examples:
  # Observe changes to services
  oc observe services
  
  # Observe changes to services, including the clusterIP and invoke a script for each
  oc observe services -a '{ .spec.clusterIP }' -- register_dns.sh

Options:
      --all-namespaces=false: If true, list the requested object(s) across all projects. Project in current context is ignored.
  -a, --argument='': Template for the arguments to be passed to each command in the format defined by --output.
  -d, --delete='': A command to run when resources are deleted. Specify multiple times to add arguments.
      --exit-after=0s: Exit with status code 0 after the provided duration, optional.
      --listen-addr=':11251': The name of an interface to listen on to expose metrics and health checking.
      --maximum-errors=20: Exit after this many errors have been detected with. May be set to -1 for no maximum.
      --names='': A command that will list all of the currently known names, optional. Specify multiple times to add arguments. Use to get notifications when objects are deleted.
      --no-headers=false: If true, skip printing information about each event prior to executing the command.
      --object-env-var='': The name of an env var to serialize the object to when calling the command, optional.
      --once=false: If true, exit with a status code 0 after all current objects have been processed.
      --output='jsonpath': Controls the template type used for the --argument flags. Supported values are gotemplate and jsonpath.
      --print-metrics-on-exit=false: If true, on exit write all metrics to stdout.
      --resync-period=0s: When non-zero, periodically reprocess every item from the server as a Sync event. Use to ensure external systems are kept up to date.
      --retry-count=2: The number of times to retry a failing command before continuing.
      --retry-on-exit-code=0: If any command returns this exit code, retry up to --retry-count times.
      --strict-templates=false: If true return an error on any field or map key that is not missing in a template.
      --type-env-var='': The name of an env var to set with the type of event received ('Sync', 'Updated', 'Deleted', 'Added') to the reaction command or --delete.

Use "oc options" for a list of global command-line options (applies to all commands).
