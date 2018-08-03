Convert config files between different API versions. Both YAML and JSON formats are accepted. 

The command takes filename, directory, or URL as input, and convert it into format of version specified by --output-version flag. If target version is not specified or not supported, convert to latest version. 

The default output will be printed to stdout in YAML format. One can use -o option to change to output destination.

Usage:
  oc convert -f FILENAME [options]

Examples:
  # Convert 'pod.yaml' to latest version and print to stdout.
  oc convert -f pod.yaml
  
  # Convert the live state of the resource specified by 'pod.yaml' to the latest version
  # and print to stdout in json format.
  oc convert -f pod.yaml --local -o json
  
  # Convert all files under current directory to latest version and create them all.
  oc convert -f . | oc create -f -

Options:
      --allow-missing-template-keys=true: If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to golang and jsonpath output formats.
  -f, --filename=[]: Filename, directory, or URL to files to need to get converted.
      --include-extended-apis=true: If true, include definitions of new APIs via calls to the API server. [default true]
      --local=true: If true, convert will NOT try to contact api-server but run locally.
      --no-headers=false: When using the default or custom-column output format, don't print headers (default print headers).
  -o, --output='': Output format. One of: json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=... See custom columns [http://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns], golang template [http://golang.org/pkg/text/template/#pkg-overview] and jsonpath template [http://kubernetes.io/docs/user-guide/jsonpath].
      --output-version='': Output the formatted object with the given group version (for ex: 'extensions/v1beta1').)
  -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests organized within the same directory.
  -a, --show-all=true: When printing, show all resources (false means hide terminated pods.)
      --show-labels=false: When printing, show all labels as the last column (default hide labels column)
      --sort-by='': If non-empty, sort list types using this field specification.  The field specification is expressed as a JSONPath expression (e.g. '{.metadata.name}'). The field in the API resource specified by this JSONPath expression must be an integer or a string.
      --template='': Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format is golang templates [http://golang.org/pkg/text/template/#pkg-overview].
      --validate=false: If true, use a schema to validate the input before sending it

Use "oc options" for a list of global command-line options (applies to all commands).
