Documentation of resources. 

Possible resource types include: pods (po), services (svc), replicationcontrollers (rc), nodes (no), events (ev), componentstatuses (cs), limitranges (limits), persistentvolumes (pv), persistentvolumeclaims (pvc), resourcequotas (quota), namespaces (ns) or endpoints (ep).

Usage:
  oc explain RESOURCE [options]

Examples:
  # Get the documentation of the resource and its fields
  oc explain pods
  
  # Get the documentation of a specific field of a resource
  oc explain pods.spec.containers

Options:
      --api-version='': Get different explanations for particular API version
      --include-extended-apis=true: If true, include definitions of new APIs via calls to the API server. [default true]
      --recursive=false: Print the fields of fields (Currently only 1 level deep)

Use "oc options" for a list of global command-line options (applies to all commands).
