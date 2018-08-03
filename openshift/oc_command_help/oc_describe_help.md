Show details of a specific resource 

This command joins many API calls together to form a detailed description of a given resource.

Usage:
  oc describe (-f FILENAME | TYPE [NAME_PREFIX | -l label] | TYPE/NAME) [options]

Examples:
  # Provide details about the ruby-22-centos7 image repository
  oc describe imageRepository ruby-22-centos7
  
  # Provide details about the ruby-sample-build build configuration
  oc describe bc ruby-sample-build

Options:
      --all-namespaces=false: If present, list the requested object(s) across all namespaces. Namespace in current context is ignored even if specified with --namespace.
  -f, --filename=[]: Filename, directory, or URL to files containing the resource to describe
      --include-extended-apis=true: If true, include definitions of new APIs via calls to the API server. [default true]
      --include-uninitialized=false: If true, the kubectl command applies to uninitialized objects. If explicitly set to false, this flag overrides other flags that make the kubectl commands apply to uninitialized objects, e.g., "--all". Objects with empty metadata.initializers are regarded as initialized.
  -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests organized within the same directory.
  -l, --selector='': Selector (label query) to filter on, supports '=', '==', and '!='.(e.g. -l key1=value1,key2=value2)
      --show-events=true: If true, display events related to the described object.

Use "oc options" for a list of global command-line options (applies to all commands).
