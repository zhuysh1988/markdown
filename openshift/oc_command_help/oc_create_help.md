Create a resource by filename or stdin 

JSON and YAML formats are accepted.

Usage:
  oc create -f FILENAME [options]

Examples:
  # Create a pod using the data in pod.json.
  oc create -f pod.json
  
  # Create a pod based on the JSON passed into stdin.
  cat pod.json | oc create -f -

Available Commands:
  clusterresourcequota Create cluster resource quota resource.
  clusterrole          Create a ClusterRole.
  clusterrolebinding   Create a ClusterRoleBinding for a particular ClusterRole
  configmap            Create a configmap from a local file, directory or literal value
  deployment           Create a deployment with the specified name.
  deploymentconfig     Create deployment config with default options that uses a given image.
  identity             Manually create an identity (only needed if automatic creation is disabled).
  imagestream          Create a new empty image stream.
  imagestreamtag       Create a new image stream tag.
  namespace            Create a namespace with the specified name
  poddisruptionbudget  Create a pod disruption budget with the specified name.
  policybinding        Create a policy binding that references the policy in the targeted namespace.
  priorityclass        Create a priorityclass with the specified name.
  quota                Create a quota with the specified name.
  role                 Create a role with single rule.
  rolebinding          Create a RoleBinding for a particular Role or ClusterRole
  route                Expose containers externally via secured routes
  secret               Create a secret using specified subcommand
  service              Create a service using specified subcommand.
  serviceaccount       Create a service account with the specified name
  user                 Manually create a user (only needed if automatic creation is disabled).
  useridentitymapping  Manually map an identity to a user.

Options:
      --allow-missing-template-keys=true: If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to golang and jsonpath output formats.
      --dry-run=false: If true, only print the object that would be sent, without sending it.
      --edit=false: Edit the API resource before creating
  -f, --filename=[]: Filename, directory, or URL to files to use to create the resource
      --include-extended-apis=true: If true, include definitions of new APIs via calls to the API server. [default true]
      --no-headers=false: When using the default or custom-column output format, don't print headers (default print headers).
  -o, --output='': Output format. One of: json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=... See custom columns [http://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns], golang template [http://golang.org/pkg/text/template/#pkg-overview] and jsonpath template [http://kubernetes.io/docs/user-guide/jsonpath].
      --raw='': Raw URI to POST to the server.  Uses the transport specified by the kubeconfig file.
      --record=false: Record current kubectl command in the resource annotation. If set to false, do not record the command. If set to true, record the command. If not set, default to updating the existing annotation value only if one already exists.
  -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests organized within the same directory.
      --save-config=false: If true, the configuration of current object will be saved in its annotation. Otherwise, the annotation will be unchanged. This flag is useful when you want to perform kubectl apply on this object in the future.
  -l, --selector='': Selector (label query) to filter on, supports '=', '==', and '!='.(e.g. -l key1=value1,key2=value2)
  -a, --show-all=true: When printing, show all resources (false means hide terminated pods.)
      --show-labels=false: When printing, show all labels as the last column (default hide labels column)
      --sort-by='': If non-empty, sort list types using this field specification.  The field specification is expressed as a JSONPath expression (e.g. '{.metadata.name}'). The field in the API resource specified by this JSONPath expression must be an integer or a string.
      --template='': Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format is golang templates [http://golang.org/pkg/text/template/#pkg-overview].
      --validate=false: If true, use a schema to validate the input before sending it
      --windows-line-endings=false: Only relevant if --edit=true. Defaults to the line ending native to your platform.

Use "oc <command> --help" for more information about a given command.
Use "oc options" for a list of global command-line options (applies to all commands).
