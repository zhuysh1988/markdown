Update field(s) of a resource using strategic merge patch 

JSON and YAML formats are accepted.

Usage:
  oc patch (-f FILENAME | TYPE NAME) -p PATCH [options]

Examples:
  # Partially update a node using strategic merge patch
  oc patch node k8s-node-1 -p '{"spec":{"unschedulable":true}}'

Options:
      --allow-missing-template-keys=true: If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to golang and jsonpath output formats.
  -f, --filename=[]: Filename, directory, or URL to files identifying the resource to update
      --include-extended-apis=true: If true, include definitions of new APIs via calls to the API server. [default true]
      --local=false: If true, patch will operate on the content of the file, not the server-side resource.
      --no-headers=false: When using the default or custom-column output format, don't print headers (default print headers).
  -o, --output='': Output format. One of: json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=... See custom columns [http://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns], golang template [http://golang.org/pkg/text/template/#pkg-overview] and jsonpath template [http://kubernetes.io/docs/user-guide/jsonpath].
  -p, --patch='': The patch to be applied to the resource JSON file.
      --record=false: Record current kubectl command in the resource annotation. If set to false, do not record the command. If set to true, record the command. If not set, default to updating the existing annotation value only if one already exists.
  -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests organized within the same directory.
  -a, --show-all=true: When printing, show all resources (false means hide terminated pods.)
      --show-labels=false: When printing, show all labels as the last column (default hide labels column)
      --sort-by='': If non-empty, sort list types using this field specification.  The field specification is expressed as a JSONPath expression (e.g. '{.metadata.name}'). The field in the API resource specified by this JSONPath expression must be an integer or a string.
      --template='': Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format is golang templates [http://golang.org/pkg/text/template/#pkg-overview].
      --type='strategic': The type of patch being provided; one of [json merge strategic]

Use "oc options" for a list of global command-line options (applies to all commands).
