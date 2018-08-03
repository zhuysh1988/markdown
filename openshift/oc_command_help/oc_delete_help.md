Delete a resource 

JSON and YAML formats are accepted. 

If both a filename and command line arguments are passed, the command line arguments are used and the filename is ignored. 

Note that the delete command does NOT do resource version checks, so if someone submits an update to a resource right when you submit a delete, their update will be lost along with the rest of the resource.

Usage:
  oc delete ([-f FILENAME] | TYPE [(NAME | -l label | --all)]) [options]

Examples:
  # Delete a pod using the type and ID specified in pod.json.
  oc delete -f pod.json
  
  # Delete a pod based on the type and ID in the JSON passed into stdin.
  cat pod.json | oc delete -f -
  
  # Delete pods and services with label name=myLabel.
  oc delete pods,services -l name=myLabel
  
  # Delete a pod with name node-1-vsjnm.
  oc delete pod node-1-vsjnm
  
  # Delete all resources associated with a running app, includes
  # buildconfig,deploymentconfig,service,imagestream,route and pod,
  # where 'appName' is listed in 'Labels' of 'oc describe [resource] [resource name]' output.
  oc delete all -l app=appName
  
  # Delete all pods
  oc delete pods --all

Options:
      --all=false: Delete all resources, including uninitialized ones, in the namespace of the specified resource types.
      --cascade=true: If true, cascade the deletion of the resources managed by this resource (e.g. Pods created by a ReplicationController).  Default true.
  -f, --filename=[]: Filename, directory, or URL to files containing the resource to delete.
      --force=false: Immediate deletion of some resources may result in inconsistency or data loss and requires confirmation.
      --grace-period=-1: Period of time in seconds given to the resource to terminate gracefully. Ignored if negative.
      --ignore-not-found=false: Treat "resource not found" as a successful delete. Defaults to "true" when --all is specified.
      --include-extended-apis=true: If true, include definitions of new APIs via calls to the API server. [default true]
      --include-uninitialized=false: If true, the kubectl command applies to uninitialized objects. If explicitly set to false, this flag overrides other flags that make the kubectl commands apply to uninitialized objects, e.g., "--all". Objects with empty metadata.initializers are regarded as initialized.
      --now=false: If true, resources are signaled for immediate shutdown (same as --grace-period=1).
  -o, --output='': Output mode. Use "-o name" for shorter output (resource/name).
  -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests organized within the same directory.
  -l, --selector='': Selector (label query) to filter on, not including uninitialized ones.
      --timeout=0s: The length of time to wait before giving up on a delete, zero means determine a timeout from the size of the object

Use "oc options" for a list of global command-line options (applies to all commands).
