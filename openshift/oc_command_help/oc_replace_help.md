Replace a resource by filename or stdin 

JSON and YAML formats are accepted.

Usage:
  oc replace -f FILENAME [options]

Examples:
  # Replace a pod using the data in pod.json.
  oc replace -f pod.json
  
  # Replace a pod based on the JSON passed into stdin.
  cat pod.json | oc replace -f -
  
  # Force replace, delete and then re-create the resource
  oc replace --force -f pod.json

Options:
      --cascade=false: Only relevant during a force replace. If true, cascade the deletion of the resources managed by this resource (e.g. Pods created by a ReplicationController).
  -f, --filename=[]: Filename, directory, or URL to files to use to replace the resource.
      --force=false: Delete and re-create the specified resource
      --grace-period=-1: Only relevant during a force replace. Period of time in seconds given to the old resource to terminate gracefully. Ignored if negative.
      --include-extended-apis=true: If true, include definitions of new APIs via calls to the API server. [default true]
  -o, --output='': Output mode. Use "-o name" for shorter output (resource/name).
      --record=false: Record current kubectl command in the resource annotation. If set to false, do not record the command. If set to true, record the command. If not set, default to updating the existing annotation value only if one already exists.
  -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests organized within the same directory.
      --save-config=false: If true, the configuration of current object will be saved in its annotation. Otherwise, the annotation will be unchanged. This flag is useful when you want to perform kubectl apply on this object in the future.
      --timeout=0s: Only relevant during a force replace. The length of time to wait before giving up on a delete of the old resource, zero means determine a timeout from the size of the object. Any other values should contain a corresponding time unit (e.g. 1s, 2m, 3h).
      --validate=false: If true, use a schema to validate the input before sending it

Use "oc options" for a list of global command-line options (applies to all commands).
