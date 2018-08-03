Extract files out of secrets and config maps 

The extract command makes it easy to download the contents of a config map or secret into a directory. Each key in the config map or secret is created as a separate file with the name of the key, as it is when you mount a secret or config map into a container. 

You may extract the contents of a secret or config map to standard out by passing '-' to --to. The names of each key will be written to stdandard error. 

You can limit which keys are extracted with the --keys=NAME flag, or set the directory to extract to with --to=DIRECTORY.

Usage:
  oc extract RESOURCE/NAME [--to=DIRECTORY] [--keys=KEY ...] [options]

Examples:
  # extract the secret "test" to the current directory
  oc extract secret/test
  
  # extract the config map "nginx" to the /tmp directory
  oc extract configmap/nginx --to=/tmp
  
  # extract the config map "nginx" to STDOUT
  oc extract configmap/nginx --to=-
  
  # extract only the key "nginx.conf" from config map "nginx" to the /tmp directory
  oc extract configmap/nginx --to=/tmp --keys=nginx.conf

Options:
      --allow-missing-template-keys=true: If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to golang and jsonpath output formats.
      --confirm=false: If true, overwrite files that already exist.
  -f, --filename=[]: Filename, directory, or URL to file to identify to extract the resource.
      --keys=[]: An optional list of keys to extract (default is all keys).
      --no-headers=false: When using the default or custom-column output format, don't print headers (default print headers).
  -o, --output='': Output format. One of: json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=... See custom columns [http://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns], golang template [http://golang.org/pkg/text/template/#pkg-overview] and jsonpath template [http://kubernetes.io/docs/user-guide/jsonpath].
  -a, --show-all=true: When printing, show all resources (false means hide terminated pods.)
      --show-labels=false: When printing, show all labels as the last column (default hide labels column)
      --sort-by='': If non-empty, sort list types using this field specification.  The field specification is expressed as a JSONPath expression (e.g. '{.metadata.name}'). The field in the API resource specified by this JSONPath expression must be an integer or a string.
      --template='': Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format is golang templates [http://golang.org/pkg/text/template/#pkg-overview].
      --to='.': Directory to extract files to.

Use "oc options" for a list of global command-line options (applies to all commands).
