Idle scalable resources 

Idling discovers the scalable resources (such as deployment configs and replication controllers) associated with a series of services by examining the endpoints of the service. Each service is then marked as idled, the associated resources are recorded, and the resources are scaled down to zero replicas. 

Upon receiving network traffic, the services (and any associated routes) will "wake up" the associated resources by scaling them back up to their previous scale.

Usage:
  oc idle (SERVICE_ENDPOINTS... | -l label | --all | --resource-names-file FILENAME) [options]

Examples:
  # Idle the scalable controllers associated with the services listed in to-idle.txt
  $ oc idle --resource-names-file to-idle.txt

Options:
      --all=false: if true, select all services in the namespace
      --all-namespaces=false: if true, select services across all namespaces
      --dry-run=false: If true, only print the annotations that would be written, without annotating or idling the relevant objects
      --resource-names-file='': file containing list of services whose scalable resources to idle
  -l, --selector='': Selector (label query) to use to select services

Use "oc options" for a list of global command-line options (applies to all commands).
